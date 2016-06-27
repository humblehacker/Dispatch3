//
// Created by David Whetstone on 6/27/16.
//

import Foundation

let logQueue = DispatchQueue(label: "com.humblehacker.logQueue")

func log(message: String)
{
    logQueue.async { print("[\(NSThread.currentThread())] \(message)") }
}

