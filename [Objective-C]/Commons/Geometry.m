//
//  Geometry.m
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import "Geometry.h"

@implementation Geometry
{
    CGRect _rect;
}

+(Geometry *(^)(CGSize))size
{
    return ^id(CGSize size) {
        Geometry *g = [[Geometry alloc] init];
        g->_rect = CGRectMake(0, 0, size.width, size.height);
        return g;
    };
}
+(Geometry *(^)(CGRect))rect
{
    return ^id(CGRect rect) {
        Geometry *g = [[Geometry alloc] init];
        g->_rect = rect;
        return g;
    };
}

+(Geometry *(^)(CGPoint))point {
    return ^id(CGPoint point) {
        Geometry *g = [[Geometry alloc] init];
        g->_rect = CGRectMake(point.x, point.y, 0, 0);
        return g;
    };
}

-(Geometry *(^)(CGSize))fill {
    return ^id(CGSize sizeToFill) {
        CGSize size = _rect.size;
        float ratio = size.width / size.height;
        CGSize szFill = ratio <  sizeToFill.width / sizeToFill.height ? CGSizeMake(sizeToFill.width, sizeToFill.width / ratio) : CGSizeMake(sizeToFill.height * ratio, sizeToFill.height);
        CGPoint pntFill = CGPointMake(sizeToFill.width/2.-szFill.width/2., sizeToFill.height/2.-szFill.height/2.);
        _rect =  CGRectMake(pntFill.x, pntFill.y, szFill.width, szFill.height);
        return self;
    };
}

-(Geometry *(^)(CGSize))fit
{
    return ^id(CGSize sizeToFit) {
        CGSize size = _rect.size;
        float ratio = size.width / size.height;
        CGSize szFit = (ratio > sizeToFit.width / sizeToFit.height) ? CGSizeMake(sizeToFit.width, sizeToFit.width / ratio) : CGSizeMake(sizeToFit.height * ratio, sizeToFit.height);
        CGPoint pntFit = CGPointMake(sizeToFit.width/2.-szFit.width/2., sizeToFit.height/2.-szFit.height/2.);
        _rect = CGRectMake(pntFit.x, pntFit.y, szFit.width, szFit.height);
        return self;
    };
}
-(Geometry *(^)(CGFloat))scale
{
    return ^id(CGFloat scale) {
        _rect = CGRectMake(_rect.origin.x*scale, _rect.origin.y*scale, _rect.size.width*scale, _rect.size.height*scale);
        return self;
    };
}

-(Geometry *(^)(CGFloat))shift
{
    return ^id(CGFloat shift) {
        _rect = CGRectMake(_rect.origin.x+shift, _rect.origin.y+shift, _rect.size.width-shift*2., _rect.size.height-shift*2.);;
        return self;
    };
}
-(Geometry *(^)(CGPoint))move
{
    return ^id(CGPoint move) {
        _rect.origin.x += move.x;
        _rect.origin.y += move.y;
        return self;
    };
}
-(Geometry *)roundf{
    _rect = CGRectMake(round(_rect.origin.x), round(_rect.origin.y), round(_rect.size.width), round(_rect.size.height));
    return self;
}

-(CGRect)rect
{
    return _rect;
}
-(CGPoint)point
{
    return _rect.origin;
}
-(CGSize)size
{
    return _rect.size;
}
-(CGPoint)center
{
    return CGPointMake(_rect.origin.x + _rect.size.width/2., _rect.origin.y + _rect.size.height/2.);
}

-(CGFloat)x
{
    return _rect.origin.x;
}
-(CGFloat)y
{
    return _rect.origin.y;
}
-(CGFloat)width
{
    return _rect.size.width;
}
-(CGFloat)height
{
    return _rect.size.height;
}
@end
