//
//  UICosteliqueScene.h
//  Akciz
//
//  Created by Олег on 05.04.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCNScene (Costelique)
-(void)addAmbientLight;
-(void)addDirectionalLight;
@end

@interface SCNNode (Costelique)
-(void)removeAllLights;
@end

NS_ASSUME_NONNULL_END
