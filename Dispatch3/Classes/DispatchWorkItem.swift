//
// Created by David Whetstone on 6/22/16.
//

import Foundation
import Dispatch

public
class DispatchWorkItem
{
    let flags: DispatchWorkItemFlags
    let qos:   DispatchQoS
    let group: DispatchGroup?
    let block: () -> Void
    static let supportedFlags: DispatchWorkItemFlags = [.barrier]

    public
    init(group: DispatchGroup? = nil, qos: DispatchQoS = .`default`, flags: DispatchWorkItemFlags = DispatchWorkItemFlags(), block: @convention(block) () -> Void)
    {
        precondition(flags.isSubsetOf(DispatchWorkItem.supportedFlags), "unsupported flags \(flags)")

        self.group = group
        self.qos = qos
        self.flags = flags
        self.block = block
    }

    public
    func perform()
    {
        block()
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
    func notify(qos qos: DispatchQoS = .`default`, flags: DispatchWorkItemFlags = DispatchWorkItemFlags(), queue: DispatchQueue, execute block: @convention(block) () -> Void)
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
}


