//
//  dispatch_async_noescape.h
//  Dispatch3
//
//  Created by David Whetstone on 6/21/16.
//  Copyright © 2016 humblehacker. All rights reserved.
//

@import Foundation;

#include <dispatch/queue.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WorkBlock)(void);

@interface DispatchHelper : NSObject

/** Hackaround that lets us call `dispatch_sync` and `dispatch_barrier_sync` with a `@noescape` block */

+ (void)dispatch_sync_noescape:(dispatch_queue_t)queue block:(WorkBlock __attribute__((noescape)))block;

+ (void)dispatch_barrier_sync_noescape:(dispatch_queue_t)queue block:(WorkBlock __attribute((noescape)))block;

@end

NS_ASSUME_NONNULL_END