//
//  Dispatch3.swift
//  Dispatch3
//
//  Created by David Whetstone on 6/21/16.
//  Copyright © 2016 humblehacker. All rights reserved.
//

import Foundation
import Dispatch

public
class DispatchQueue: DispatchObject<dispatch_queue_t>
{
    public convenience
    init(__label label: UnsafePointer<Int8>, attr: dispatch_queue_attr_t?)
    {
        let queue = dispatch_queue_create(label, attr)
        self.init(underlyingObject: queue)
    }

    public convenience
    init(label: String, attributes: DispatchQueueAttributes = .serial, target: DispatchQueue? = nil)
    {
        let queue = dispatch_queue_create(label, attributes.underlyingAttributes)
        self.init(underlyingObject: queue)
    }

    override
    init(underlyingObject: dispatch_queue_t)
    {
        super.init(underlyingObject: underlyingObject)
        annotateQueue()
    }

    public var label: String { return String(UTF8String: dispatch_queue_get_label(underlyingObject)) ?? "" }

    public var qos: DispatchQoS
    {
        return DispatchQoS(underlyingQoSClass: dispatch_queue_get_qos_class(underlyingObject, nil))
    }

    public static var main: DispatchQueue = DispatchQueue(underlyingObject: dispatch_get_main_queue())

    public class func global(attributes attributes: DispatchQueue.GlobalAttributes = .qosDefault) -> DispatchQueue
    {
        return DispatchQueue(underlyingObject: dispatch_get_global_queue(attributes.underlyingQoSClass, 0))
    }
}

extension DispatchQueue
{
    private
    func annotateQueue()
    {
        // Use `passUnretained` to avoid reference cycle
        let unmanaged: Unmanaged<DispatchQueue> = Unmanaged.passUnretained(self)
        setSpecific(key: kCurrentQueueKey, value: unmanaged)
    }

    public struct GlobalAttributes : OptionSetType {

        public let rawValue: UInt64

        public init(rawValue: UInt64)
        {
            self.rawValue = rawValue
        }

        public static let qosUserInteractive = DispatchQueue.GlobalAttributes(rawValue: 1 << 1)
        public static let qosUserInitiated   = DispatchQueue.GlobalAttributes(rawValue: 1 << 2)
        public static let qosDefault         = DispatchQueue.GlobalAttributes(rawValue: 1 << 3)
        public static let qosUtility         = DispatchQueue.GlobalAttributes(rawValue: 1 << 4)
        public static let qosBackground      = DispatchQueue.GlobalAttributes(rawValue: 1 << 5)

        var underlyingQoSClass: qos_class_t
        {
            if contains(GlobalAttributes.qosUserInteractive) { return QOS_CLASS_USER_INTERACTIVE }
            if contains(GlobalAttributes.qosUserInitiated)   { return QOS_CLASS_USER_INITIATED}
            if contains(GlobalAttributes.qosDefault)         { return QOS_CLASS_DEFAULT }
            if contains(GlobalAttributes.qosUtility)         { return QOS_CLASS_UTILITY }
            if contains(GlobalAttributes.qosBackground)      { return QOS_CLASS_BACKGROUND }
            return QOS_CLASS_BACKGROUND
        }
    }
}


// MARK: - Perform work

extension DispatchQueue
{
    /// Implementation mostly from [this Apple Dev Forum post](https://forums.developer.apple.com/thread/8002#24898)
    public func sync<T>(flags flags: DispatchWorkItemFlags = DispatchWorkItemFlags(), @noescape execute work: () throws -> T) rethrows -> T
    {
        var result: T?

        func rethrow(myerror: ErrorType) throws ->() { throw myerror }

        func perform_sync_impl(queue: dispatch_queue_t, @noescape block: () throws -> T, block2:((myerror:ErrorType) throws -> ()) ) rethrows
        {
            var blockError: ErrorType? = nil

            if flags.contains(.barrier)
            {
                DispatchHelper.dispatch_barrier_sync_noescape(queue) { do { result = try block() } catch { blockError = error } }
            }
            else
            {
                DispatchHelper.dispatch_sync_noescape(queue) { do { result = try block() } catch { blockError = error } }
            }

            if let blockError = blockError { try block2(myerror: blockError) }
        }

        try perform_sync_impl(underlyingObject, block: work, block2: rethrow)

        return result!
    }

    public
    func async(group group: DispatchGroup? = nil, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @convention(block) () -> Void)
    {
        let work = DispatchWorkItem(group: group, qos: qos, flags: flags, block: work)
        async(execute: work)
    }

    public
    func after(when: DispatchTime, execute work: @convention(block) () -> Void)
    {
        dispatch_after(when.rawValue, underlyingObject, work)
    }

    public
    func sync(execute workItem: DispatchWorkItem)
    {
        sync { workItem.block() }
    }

    public
    func async(execute workItem: DispatchWorkItem)
    {
        if let group = workItem.group
        {
            dispatch_group_async(group.underlyingObject, underlyingObject, workItem.block)
            return
        }

        dispatch_async(underlyingObject, workItem.block)
    }
}

// MARK: - Specific Values

final public class DispatchSpecificKey<T>
{
    public init() {}
}

final private class DispatchSpecificValue<T>
{
    var value: T

    init(value: T)
    {
        self.value = value
    }

    class
    func from(mutableVoidPointer mutableVoidPointer: UnsafeMutablePointer<Void>) -> DispatchSpecificValue<T>
    {
        let cOpaquePointer: COpaquePointer = COpaquePointer(mutableVoidPointer)
        let unmanaged: Unmanaged<DispatchSpecificValue<T>> = Unmanaged.fromOpaque(cOpaquePointer)
        return unmanaged.takeUnretainedValue()
    }

    var mutableVoidPointer: UnsafeMutablePointer<Void>
    {
        let unmanagedRetained: Unmanaged<DispatchSpecificValue<T>> = Unmanaged.passRetained(self)
        let cOpaquePointer: COpaquePointer = unmanagedRetained.toOpaque()
        return UnsafeMutablePointer<Void>(cOpaquePointer)
    }
}

public
extension DispatchQueue
{
    public class
    func getSpecific<T>(key key: DispatchSpecificKey<T>) -> T?
    {
        let storedKey = UnsafeMutablePointer<Void>(Unmanaged.passUnretained(key).toOpaque())

        let p = dispatch_get_specific(storedKey)
        guard p != nil else { return nil }

        let specificValue: DispatchSpecificValue<T> = DispatchSpecificValue.from(mutableVoidPointer: p)

        return specificValue.value
    }

    public
    func getSpecific<T>(key key: DispatchSpecificKey<T>) -> T?
    {
        let storedKey = UnsafeMutablePointer<Void>(Unmanaged.passUnretained(key).toOpaque())

        let p = dispatch_queue_get_specific(underlyingObject, storedKey)
        guard p != nil else { return nil }

        let specificValue: DispatchSpecificValue<T> = DispatchSpecificValue.from(mutableVoidPointer: p)

        return specificValue.value
    }

    public
    func setSpecific<T>(key key: DispatchSpecificKey<T>, value:T?)
    {
        let storedKey = UnsafeMutablePointer<Void>(Unmanaged.passUnretained(key).toOpaque())

        if let val = value
        {
            let wrappedValue = DispatchSpecificValue(value: val)
            let mutableVoidPointer: UnsafeMutablePointer<Void> = wrappedValue.mutableVoidPointer

            dispatch_queue_set_specific(underlyingObject, storedKey, mutableVoidPointer, releaseSpecificValue)
        }
        else
        {
            dispatch_queue_set_specific(underlyingObject, storedKey, nil, nil)
        }
    }
}

private
func releaseSpecificValue(specificValue mutableVoidPointer: UnsafeMutablePointer<Void>)
{
    let cOpaquePointer = COpaquePointer(mutableVoidPointer)
    let unmanaged      = Unmanaged<AnyObject>.fromOpaque(cOpaquePointer)
    unmanaged.release()
}

