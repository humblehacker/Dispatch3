//
// Created by David Whetstone on 6/22/16.
// Copyright (c) 2016 humblehacker. All rights reserved.
//

import Dispatch

public
enum DispatchTimeInterval
{
    case seconds(Int)

    case milliseconds(Int)

    case microseconds(Int)

    case nanoseconds(Int)

    func toNanoseconds() -> Int64
    {
        switch self
        {
            case seconds(let sec):
                return Int64(sec) * Int64(NSEC_PER_SEC)
            case milliseconds(let msec):
                return Int64(msec) * Int64(NSEC_PER_MSEC)
            case microseconds(let usec):
                return Int64(usec) * Int64(NSEC_PER_USEC)
            case nanoseconds(let nsec):
                return Int64(nsec)
        }
    }
}

public
enum DispatchTimeoutResult
{
    case Success
    case TimedOut
}

public
struct DispatchTime
{
    public let rawValue: dispatch_time_t

    public static func now() -> DispatchTime
    {
        return DispatchTime(rawValue: dispatch_time(DISPATCH_TIME_NOW, 0))
    }

    public static let distantFuture: DispatchTime =
    {
        return DispatchTime(rawValue: dispatch_time(DISPATCH_TIME_FOREVER, 0))
    }()

    public init(rawValue: dispatch_time_t)
    {
        self.rawValue = rawValue
    }
}

public func +(time: DispatchTime, interval: DispatchTimeInterval) -> DispatchTime
{
    return DispatchTime(rawValue: dispatch_time(time.rawValue, interval.toNanoseconds()))
}

public func +(time: DispatchTime, seconds: Double) -> DispatchTime
{
    let ns = Int64(seconds * Double(NSEC_PER_SEC))
    return DispatchTime(rawValue: dispatch_time(time.rawValue, ns))
}

public func -(time: DispatchTime, interval: DispatchTimeInterval) -> DispatchTime
{
    return DispatchTime(rawValue: dispatch_time(time.rawValue, -interval.toNanoseconds()))
}

public func -(time: DispatchTime, seconds: Double) -> DispatchTime
{
    let ns = Int64(-seconds * Double(NSEC_PER_SEC))
    return DispatchTime(rawValue: dispatch_time(time.rawValue, ns))
}

public
struct DispatchWallTime
{

}
