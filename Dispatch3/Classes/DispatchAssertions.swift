//
//  DispatchAssertions.swift
//  Dispatch3
//
//  Created by David Whetstone on 6/22/16.
//  Copyright © 2016 humblehacker. All rights reserved.
//

import Dispatch

public enum DispatchPredicate
{
    case onQueue(DispatchQueue)
    case onQueueAsBarrier(DispatchQueue)
    case notOnQueue(DispatchQueue)
}

var kCurrentQueueKey = DispatchSpecificKey<DispatchQueue>()

public func dispatchPrecondition(@autoclosure condition: () -> DispatchPredicate, file: StaticString = #file, line: UInt = #line)
{
    switch condition()
    {
    case .onQueue(let queue):
        assert(onQueue(queue), "not on expected queue", file: file, line: line)

    case .notOnQueue(let queue):
        assert(!onQueue(queue), "on unexpected queue", file: file, line: line)
        
    case .onQueueAsBarrier:
        fatalError("Not implemented")
    }
}

private func onQueue(queue: DispatchQueue) -> Bool
{
    return dispatch_get_specific(&kCurrentQueueKey) == queue.context
}