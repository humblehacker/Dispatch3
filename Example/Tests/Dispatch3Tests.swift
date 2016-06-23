//
//  Dispatch3Tests.swift
//  Dispatch3Tests
//
//  Created by David Whetstone on 6/21/16.
//  Copyright © 2016 humblehacker. All rights reserved.
//

import XCTest
@testable import Dispatch3

class Dispatch3Tests: XCTestCase {
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }

    var serialTestQueue = DispatchQueue(label: "com.humblehacker.Dispatch3Test.serial", attributes: [DispatchQueueAttributes.serial])
    var concurrentTestQueue = DispatchQueue(label: "com.humblehacker.Dispatch3Test.concurrent", attributes: [DispatchQueueAttributes.concurrent])

    func testDispatchPrecondition()
    {
        // There's no real good way to unit test assertions, so this test case exists just as a sanity check.
        // To see the preconditions in action, just invert their sense (change `onQueue` to `notOnQueue` and
        // vice-versa.

        dispatchPrecondition(.notOnQueue(serialTestQueue))
        serialTestQueue.sync { dispatchPrecondition(.onQueue(serialTestQueue)) }
    }
    
    func testSyncCanReturnValue()
    {
        XCTAssertEqual(serialTestQueue.sync { return 6 }, 6)
    }

    func testSyncBlockCanThrow()
    {
        let throwingIntBlock: ()throws->Int = { throw NSError(domain: "foo", code: 0, userInfo: nil) }
        XCTAssertThrowsError(try serialTestQueue.sync { try throwingIntBlock() })
    }

    func testAsync()
    {
        let expectation = expectationWithDescription("DispatchQueue.async")

        serialTestQueue.async
        {
            dispatchPrecondition(.onQueue(self.serialTestQueue))
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(2) { error in if error != nil { NSLog("timed out: \(error!)") } }
    }

    func testAfter()
    {
        let expectation = expectationWithDescription("DispatchQueue.async")

        serialTestQueue.after(.now() + .seconds(1))
        {
            dispatchPrecondition(.onQueue(self.serialTestQueue))
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(2) { error in if error != nil { NSLog("timed out: \(error!)") } }
    }

    func testGroupAsyncNotify()
    {
        let groupAsyncExpectation  = expectationWithDescription("DispatchGroup.async")
        let groupNotifyExpectation = expectationWithDescription("DispatchGroup.notify")

        let g = DispatchGroup()

        g.enter()

        serialTestQueue.async(group: g) { groupAsyncExpectation.fulfill() }

        g.notify(queue: serialTestQueue) { groupNotifyExpectation.fulfill() }

        g.leave()

        waitForExpectationsWithTimeout(2) { error in if error != nil { NSLog("timed out: \(error!)") } }
    }

    func testBarrierAsync()
    {
        let barrierAsyncExpectation = expectationWithDescription("DispatchQueue.barrier_async")

        for i in 0..<10
        {
            concurrentTestQueue.async
            {
                NSThread.sleepForTimeInterval(0.25)
                print("done: \(i) ")
            }
        }

        concurrentTestQueue.sync { print("submitting barrier block") }

        concurrentTestQueue.async(flags: [.barrier])
        {
            barrierAsyncExpectation.fulfill()
            print("barrier done")
        }

        waitForExpectationsWithTimeout(2) { error in if error != nil { NSLog("timed out: \(error!)") } }
    }

    func testBarrierSync()
    {
        for i in 0..<10
        {
            concurrentTestQueue.async
            {
                NSThread.sleepForTimeInterval(0.25)
                print("done: \(i) ")
            }
        }

        concurrentTestQueue.sync { print("submitting barrier block") }

        concurrentTestQueue.sync(flags: [.barrier])
        {
            print("barrier done")
        }
    }

    func testMainQueue()
    {
        let expectation = expectationWithDescription("DispatchQueue.main_queue")

        let q = DispatchQueue.main

        q.async
        {
            print("\(q.label)")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(2) { error in if error != nil { NSLog("timed out: \(error!)") } }
    }

    func testGlobalConcurrentQueue()
    {
        let expectation = expectationWithDescription("DispatchQueue.global_queue")

        let q = DispatchQueue.global(attributes: [.qosBackground])

        q.async
        {
            print("\(q.label)")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(2) { error in if error != nil { NSLog("timed out: \(error!)") } }
    }
}

































