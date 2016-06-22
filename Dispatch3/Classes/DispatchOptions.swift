//
//  DispatchQueueAttributes.swift
//  Dispatch3
//
//  Created by David Whetstone on 6/21/16.
//  Copyright © 2016 humblehacker. All rights reserved.
//

import Foundation

public
struct DispatchQueueAttributes: OptionSetType
{
    public var rawValue: UInt64

    public
    init(arrayLiteral: DispatchQueueAttributes...)
    {
        self.rawValue = arrayLiteral.reduce(0, combine: { (value, attribute) -> UInt64 in
            return value | attribute.rawValue
        })
    }

    public
    init(rawValue: UInt64)
    {
        self.rawValue = rawValue
    }

    public static let autoreleaseInherit = DispatchQueueAttributes(rawValue: 1 << 1)
    public static let autoreleaseNever = DispatchQueueAttributes(rawValue: 1 << 2)
    public static let autoreleaseWorkItem = DispatchQueueAttributes(rawValue: 1 << 3)
    public static let concurrent = DispatchQueueAttributes(rawValue: 1 << 4)
    public static let initiallyInactive = DispatchQueueAttributes(rawValue: 1 << 5)
    public static let noQoS = DispatchQueueAttributes(rawValue: 1 << 6)
    public static let qosBackground = DispatchQueueAttributes(rawValue: 1 << 7)
    public static let qosDefault = DispatchQueueAttributes(rawValue: 1 << 8)
    public static let qosUserInitiated = DispatchQueueAttributes(rawValue: 1 << 9)
    public static let qosUserInteractive = DispatchQueueAttributes(rawValue: 1 << 10)
    public static let qosUtility = DispatchQueueAttributes(rawValue: 1 << 11)
    public static let serial = DispatchQueueAttributes(rawValue: 1 << 12)
}

