//
// Created by David Whetstone on 6/22/16.
//

import Foundation
import Dispatch

public
class DispatchWorkItem
{
    let group: DispatchGroup?
    let block: dispatch_block_t

    public
    init(group: DispatchGroup? = nil, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], block: @convention(block) () -> Void)
    {
        self.group = group
        self.block = dispatch_block_create_with_qos_class(flags.underlyingBlockFlags, qos.underlyingQoSClass, Int32(qos.relativePriority), block)
    }

    public
    func perform()
    {
        fatalError("Not yet supported")
    }

    public
    func wait()
    {
        fatalError("Not yet supported")
    }

    public
    func wait(timeout timeout: DispatchTime) -> DispatchTimeoutResult
    {
        fatalError("Not yet supported")
    }

    public
    func wait(wallTimeout wallTimeout: DispatchWallTime) -> DispatchTimeoutResult
    {
        fatalError("Not yet supported")
    }

    public
    func notify(qos qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], queue: DispatchQueue, execute block: @convention(block) () -> Void)
    {
        fatalError("Not yet supported")
    }

    public
    func notify(queue queue: DispatchQueue, execute work: DispatchWorkItem)
    {
        fatalError("Not yet supported")
    }

    public
    func cancel()
    {
        fatalError("Not yet supported")
    }

    public
    var isCancelled: Bool { fatalError("Not yet supported") }
}

public
struct DispatchWorkItemFlags: OptionSetType, RawRepresentable
{
    public let rawValue: UInt

    public
    init(rawValue: UInt)
    {
        self.rawValue = rawValue
    }

    public static let barrier              = DispatchWorkItemFlags(rawValue: 1 << 0)
    public static let detached             = DispatchWorkItemFlags(rawValue: 1 << 1)
    public static let assignCurrentContext = DispatchWorkItemFlags(rawValue: 1 << 2)
    public static let noQoS                = DispatchWorkItemFlags(rawValue: 1 << 3)
    public static let inheritQoS           = DispatchWorkItemFlags(rawValue: 1 << 4)
    public static let enforceQoS           = DispatchWorkItemFlags(rawValue: 1 << 5)

    var underlyingBlockFlags : dispatch_block_flags_t
    {
        switch self
        {
            case DispatchWorkItemFlags.barrier: return DISPATCH_BLOCK_BARRIER
            case DispatchWorkItemFlags.detached: return DISPATCH_BLOCK_DETACHED
            case DispatchWorkItemFlags.assignCurrentContext: return DISPATCH_BLOCK_ASSIGN_CURRENT
            case DispatchWorkItemFlags.noQoS: return DISPATCH_BLOCK_NO_QOS_CLASS
            case DispatchWorkItemFlags.inheritQoS: return DISPATCH_BLOCK_INHERIT_QOS_CLASS
            case DispatchWorkItemFlags.enforceQoS: return DISPATCH_BLOCK_ENFORCE_QOS_CLASS
            default: return dispatch_block_flags_t(0)
        }
    }
}


