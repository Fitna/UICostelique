//
//  MetalContext.h
//  ScreenStitch
//
//  Created by Олег on 24.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface MetalContext : NSObject
@property id<MTLDevice> device;
@property id<MTLLibrary> library;
@property id<MTLCommandQueue> commandQueue;

+(MetalContext *)defaultContext;
@end
