//
//  UICosteliqueScene.m
//  Akciz
//
//  Created by Олег on 05.04.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "UICosteliqueScene.h"

@implementation  SCNScene (Costelique)

-(void)addAmbientLight {
    [self.rootNode addChildNode:({
        SCNNode *node = [[SCNNode alloc] init];
        node.light = ({
            SCNLight *light = [[SCNLight alloc] init];
            light.intensity = 300;
            light.type = SCNLightTypeAmbient;
            light;
        });
        node;
    })];
}

-(void)addDirectionalLight {

    [self.rootNode addChildNode:({
        SCNNode *node = [[SCNNode alloc] init];
        node.rotation = SCNVector4Make(1, 1, 0, M_PI/2.);
        node.light = ({
            SCNLight *light = [[SCNLight alloc] init];
            light.intensity = 1000;
            light.type = SCNLightTypeDirectional;
            light;
        });
        node;
    })];
}

@end


@implementation SCNNode (Costelique)
-(void)removeAllLights {
    for (SCNNode *node in self.childNodes) {
        if (node.light) {
            [node removeFromParentNode];
        } else {
            [node removeAllLights];
        }
    }
}
@end
