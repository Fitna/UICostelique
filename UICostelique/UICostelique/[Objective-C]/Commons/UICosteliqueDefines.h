//
//  UICosteliqueDefines.h
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#ifndef UICosteliqueDefines_h
#define UICosteliqueDefines_h

#define CORES_COUNT [[NSProcessInfo processInfo] activeProcessorCount]

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define INIT_TOKEN dispatch_once_t ak_initToken;

#define INIT_ALL(foo) \
- (instancetype)init \
{ if (self = [super init]) { \
dispatch_once(&ak_initToken, ^{ [self foo]; }); } \
return self; } \
\
- (instancetype)initWithCoder:(NSCoder *)coder \
{ self = [super initWithCoder:coder]; \
if (self) { dispatch_once(&ak_initToken, ^{ [self foo]; }); } \
return self; }\
\
- (instancetype)initWithFrame:(CGRect)frame \
{ self = [super initWithFrame:frame]; \
if (self) { dispatch_once(&ak_initToken, ^{ [self foo]; }); } \
return self; }

#define guard(param) if (param) { }

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_HEIGHT_GTE_568 ( [[UIScreen mainScreen] bounds].size.height <= 568.0f )
#define IS_IPHONE_5_OR_OLDER ( IS_IPHONE && IS_HEIGHT_GTE_568 )


#define weakself(ARGS) \
"weakself should be called as @weakself" @"" ? \
({  __weak typeof(self) _private_weakSelf = self; \
ARGS { \
__strong typeof(_private_weakSelf) self __attribute__((unused)) = _private_weakSelf; \
return ^ (void) {

#define weakselfnotnil(ARGS) \
"weakself should be called as @weakself" @"" ? \
({  __weak typeof(self) _private_weakSelf = self; \
ARGS { \
__strong typeof(_private_weakSelf) self __attribute__((unused)) = _private_weakSelf; \
return ^ (void) { if (self)

#define weakselfend \
try {} @finally {} } (); }; \
}) : nil

#endif /* UICosteliqueDefines_h */

#ifndef DEBUG
#define NSLog(x,...) (void *)(x)
#endif
