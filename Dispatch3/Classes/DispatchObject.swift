//
//  DispatchObject.swift
//  Dispatch3
//
//  Created by David Whetstone on 6/22/16.
//  Copyright © 2016 humblehacker. All rights reserved.
//

import Dispatch

public
class DispatchObject<T>
{
    let underlyingObject: T

    init(underlyingObject: T)
    {
        self.underlyingObject = underlyingObject
    }

    public
    func activate()
    {
        fatalError("Not implemented")
    }

    public
    func suspend()
    {
        dispatch_suspend(underlyingObject as! dispatch_object_t)
    }

    public
    func resume()
    {
        dispatch_resume(underlyingObject as! dispatch_object_t)
    }
}

