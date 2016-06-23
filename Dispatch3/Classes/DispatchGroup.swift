//
// Created by David Whetstone on 6/22/16.
//

import Foundation
import Dispatch

public class DispatchGroup : DispatchObject<dispatch_group_t>
{
    public
    init()
    {
        super.init(underlyingObject: dispatch_group_create())
    }
}

/// dispatch_group

extension DispatchGroup
{
    public
    func notify(qos qos: DispatchQoS = .`default`, flags: DispatchWorkItemFlags = DispatchWorkItemFlags(), queue: DispatchQueue, execute work: @convention(block) () -> ())
    {
        let workItem = DispatchWorkItem(group: self, qos: qos, flags: flags, block: work)
        notify(queue: queue, work: workItem)
    }

    public
    func notify(queue queue: DispatchQueue, work: DispatchWorkItem)
    {
        dispatch_group_notify(underlyingObject, queue.underlyingObject, work.block)
    }

    public
    func wait()
    {
        wait(timeout: DispatchTime.distantFuture)
    }

    public
    func wait(timeout timeout: DispatchTime) -> DispatchTimeoutResult
    {
        return dispatch_group_wait(underlyingObject, timeout.rawValue) == 0 ? .Success : .TimedOut
    }

    public
    func wait(wallTimeout timeout: DispatchWallTime) -> DispatchTimeoutResult
    {
        fatalError("Not yet supported")
    }
}

extension DispatchGroup
{
    public
    func enter()
    {
        dispatch_group_enter(underlyingObject)
    }

    public
    func leave()
    {
        dispatch_group_leave(underlyingObject)
    }
}
