//
//  dispatch_async_noescape.c
//  Dispatch3
//
//  Created by David Whetstone on 6/21/16.
//  Copyright © 2016 humblehacker. All rights reserved.
//

#include "DispatchHelper.h"

@implementation DispatchHelper

+ (void)dispatch_sync_noescape:(dispatch_queue_t)queue block:(WorkBlock)block
{
    dispatch_sync(queue, block);
}

@end