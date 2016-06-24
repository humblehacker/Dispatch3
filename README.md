# Dispatch3

[![CI Status](http://img.shields.io/travis/David Whetstone/Dispatch3.svg?style=flat)](https://travis-ci.org/David Whetstone/Dispatch3)
[![Version](https://img.shields.io/cocoapods/v/Dispatch3.svg?style=flat)](http://cocoapods.org/pods/Dispatch3)
[![License](https://img.shields.io/cocoapods/l/Dispatch3.svg?style=flat)](http://cocoapods.org/pods/Dispatch3)
[![Platform](https://img.shields.io/cocoapods/p/Dispatch3.svg?style=flat)](http://cocoapods.org/pods/Dispatch3)

Dispatch3 is a wrapper around the iOS9 Dispatch framework providing the same syntax and functionality as the new Dispatch framework in iOS10.

## Rationale

I was watching the WWDC session on GCD in Swift 3 and wanted to start using the new and much cleaner syntax without having to wait for Xcode 8 to be released.  So I decided to see if I could replicate a subset of its functionality in XCode 7.3.

## What's done?

So far, it only contains the basics - but you can still do a lot with those!  Here's what you can do:

```swift
import Dispatch3

class DispatchStuff
{
    let sq = DispatchQueue("com.example.some_queue", attr: .serial)
    let cq = DispatchQueue("com.example.another_queue", attr: .concurrent)

    let x = 5

    func foo() throws
    {
        // You can return from a sync closure! And you don't have to
        // reference self (closure is @noescape)

        let y = sq.sync { return x }

        // You can also throw from a sync closure!
        try sq.sync { throw SomeException }

        // dispatch_after is much simpler
        sq.after(.now() + 5) { print "Isn't that much easier?" }
        sq.after(.now() + .milliseconds(500)) { print "No conversions necessary" }
        
        // Dispatch groups!
        let g = DispatchGroup()
        cq.async(group: g) { /* Do the thing */ }
        cq.async(group: g) { /* Do the other thing */ }
        g.enter()
        someObject.customThing(completion: { g.leave() })
        group.notify { /* Do when thing, other thing, and custom thing are done */ }
        
        // Barrier blocks!
        for i in 0..<10
        {
            cq.async { /* Do the thing */ }
        }
        
        cq.async(flags: .barrier) { /* called after cq is drained */ }
        
        // Dispatch on the main queue
        DispatchQueue.main.async { /* update the UI */ }
        
        // Dispatch on a global queue
        DispatchQueue.global(attributes: .qosBackground).async { ... }
    }

    func bar()
    {
        // Preconditions!
        dispatchPrecondition(.onQueue(sq))
        dispatchPrecondition(.notOnQueue(cq))
        print("I feel safer already")
    }
}
```

## Next steps

This project will never reach 100% compatibility, and most likely won't even get close.  After all, it's got a limited shelf-life - becoming obsolete as soon as Xcode 8 is released.  With that said, I will be adding more features as I need them.  Feel free to contribute others.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Dispatch3 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Dispatch3"
```

## Author

David Whetstone, david@humblehacker.com

## License

Dispatch3 is available under the MIT license. See the LICENSE file for more info.
