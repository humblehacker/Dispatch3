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
    init(rawValue: UInt64)
    {
        self.rawValue = rawValue
    }

    public static let serial              = DispatchQueueAttributes(rawValue: 0)
    public static let concurrent          = DispatchQueueAttributes(rawValue: 1 << 1 )

    /* Unsupported
    public static let initiallyInactive   = DispatchQueueAttributes(rawValue: 1 << 2 )
    public static let autoreleaseInherit  = DispatchQueueAttributes(rawValue: 1 << 3 )
    public static let autoreleaseWorkItem = DispatchQueueAttributes(rawValue: 1 << 4 )
    public static let autoreleaseNever    = DispatchQueueAttributes(rawValue: 1 << 5 )
    */

    public static let qosUserInteractive  = DispatchQueueAttributes(rawValue: 1 << 6 )
    public static let qosUserInitiated    = DispatchQueueAttributes(rawValue: 1 << 7 )
    public static let qosDefault          = DispatchQueueAttributes(rawValue: 1 << 8 )
    public static let qosUtility          = DispatchQueueAttributes(rawValue: 1 << 9 )
    public static let qosBackground       = DispatchQueueAttributes(rawValue: 1 << 10)
    
    /* Unsupported
    public static let noQoS               = DispatchQueueAttributes(rawValue: 1 << 11)
    */

    var underlyingAttributes: dispatch_queue_attr_t
    {
        var attr:    dispatch_queue_attr_t! = DISPATCH_QUEUE_SERIAL
        var qosAttr: dispatch_qos_class_t   = QOS_CLASS_UNSPECIFIED

        if contains(.concurrent) { attr = DISPATCH_QUEUE_CONCURRENT }

        if contains(.qosUserInteractive)     { qosAttr = QOS_CLASS_USER_INTERACTIVE }
        else if contains(.qosUserInitiated)  { qosAttr = QOS_CLASS_USER_INITIATED }
        else if contains(.qosDefault)        { qosAttr = QOS_CLASS_DEFAULT }
        else if contains(.qosUtility)        { qosAttr = QOS_CLASS_UTILITY }
        else if contains(.qosBackground)     { qosAttr = QOS_CLASS_BACKGROUND }

        return dispatch_queue_attr_make_with_qos_class(attr, qosAttr, 0)
    }
}
                                                                                   
public struct DispatchQoS : Equatable
{
    public let qosClass: DispatchQoS.QoSClass
    public let relativePriority: Int

    public static let background      = DispatchQoS(qosClass: .background)
    public static let utility         = DispatchQoS(qosClass: .utility)
    public static let `default`       = DispatchQoS(qosClass: .`default`)
    public static let userInitiated   = DispatchQoS(qosClass: .userInitiated)
    public static let userInteractive = DispatchQoS(qosClass: .userInteractive)
    public static let unspecified     = DispatchQoS(qosClass: .unspecified)

    public enum QoSClass
    {
        case background
        case utility
        case `default`
        case userInitiated
        case userInteractive
        case unspecified
    }

    public init(qosClass: DispatchQoS.QoSClass, relativePriority: Int = 0)
    {
        self.relativePriority = relativePriority
        self.qosClass = qosClass
    }

    init(underlyingQoSClass: qos_class_t)
    {
        self.relativePriority = 0

        switch underlyingQoSClass
        {
            case QOS_CLASS_BACKGROUND: qosClass = .background
            case QOS_CLASS_UTILITY: qosClass = .utility
            case QOS_CLASS_DEFAULT: qosClass = .`default`
            case QOS_CLASS_USER_INITIATED: qosClass = .userInitiated
            case QOS_CLASS_USER_INTERACTIVE: qosClass = .userInteractive
            case QOS_CLASS_UNSPECIFIED: qosClass = .unspecified
            default: qosClass = .`default`
        }
    }

    var underlyingQoSClass: qos_class_t
    {
        switch qosClass
        {
            case .background: return QOS_CLASS_BACKGROUND
            case .utility: return QOS_CLASS_UTILITY
            case .`default`: return QOS_CLASS_DEFAULT
            case .userInitiated: return QOS_CLASS_USER_INITIATED
            case .userInteractive: return QOS_CLASS_USER_INTERACTIVE
            case .unspecified: return QOS_CLASS_UNSPECIFIED
        }
    }
}

public func ==(a: DispatchQoS, b: DispatchQoS) -> Bool
{
    return a.qosClass == b.qosClass && a.relativePriority == b.relativePriority
}