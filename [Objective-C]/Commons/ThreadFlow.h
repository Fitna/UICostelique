//
//  ThreadFlow.h
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreadFlow : NSObject
@property (readonly) NSString *name;
+(ThreadFlow *)flowNamed:(NSString *)str;
-(void)dispatchAfter:(float)sec block:(dispatch_block_t)block;
@end
