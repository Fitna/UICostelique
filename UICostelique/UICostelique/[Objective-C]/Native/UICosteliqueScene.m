//
//  UICosteliqueScene.m
//  Akciz
//
//  Created by Олег on 05.04.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

#import "UICosteliqueScene.h"
#import "UICosteliqueNative.h"

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

-(void)standartLightning {
    [self removeAllLights];
    __weak typeof(self) weakself = self;
    void(^addOmni)(SCNVector3) = ^(SCNVector3 position){
        SCNNode *lightNode = [SCNNode node];
        lightNode.light = [SCNLight light];
        lightNode.light.type = SCNLightTypeOmni;
        lightNode.position = position;
        lightNode.light.intensity = 200;
        lightNode.light.color = [UIColor colorWidthHexString:@"F7FFD0"];
        [weakself addChildNode:lightNode];
    };

    addOmni(SCNVector3Make(0, 0.1, 2));
    addOmni(SCNVector3Make(-3, 0, 0));
    addOmni(SCNVector3Make(3, 0, 0));
    addOmni(SCNVector3Make(0, 3, 0));
    addOmni(SCNVector3Make(0, -3, 0));


    [self addChildNode:({
        SCNNode *node = [[SCNNode alloc] init];
        node.light = ({
            SCNLight *light = [[SCNLight alloc] init];
            light.intensity = 100;
            light.type = SCNLightTypeAmbient;
            light;
        });
        node;
    })];
}


-(NSArray *)childNodesContainingString:(NSString *)name recursive:(BOOL)recursive {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (SCNNode *node in self.childNodes) {
        if ([node.name containsString:name]) {
            [arr addObject: node];
        } else if (recursive) {
            [arr addObjectsFromArray: [node childNodesContainingString:name recursive: true]];
        }
    }
    return [arr copy];
}

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
