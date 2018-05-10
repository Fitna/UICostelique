//
//  RadialGradientLayer.h
//  Karma and destiny
//
//  Created by Олег on 16.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CALayer.h>
#import <UIKit/UIColor.h>

@interface RadialGradientLayer : CALayer {
    float _controlPoints[3];
}
@property (readonly) float *controlPoints;
@property bool gradientAnimated;
@property CGPoint gradientCenter;
@property UIColor *colorCenter;
@property UIColor *colorEdge;
@end
