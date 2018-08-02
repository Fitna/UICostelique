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


-(void)standartLightning {
    [self.rootNode removeAllLights];
    void(^addOmni)(SCNVector3) = ^(SCNVector3 position){
        SCNNode *lightNode = [SCNNode node];
        lightNode.light = [SCNLight light];
        lightNode.light.type = SCNLightTypeOmni;
        lightNode.position = position;
        lightNode.light.intensity = 500;
        lightNode.light.color = [UIColor colorWidthHexString:@"F0F4C4"];
        [self.rootNode addChildNode:lightNode];
    };

//    for (int i = 0; i < 10; i++) {
//        double theta = 2 * M_PI * arc4random()/UINT32_MAX;
//        double phi = M_PI * arc4random()/UINT32_MAX;
//        double x = 4 * sin(phi) * cos(theta);
//        double y = 4 * sin(phi) * sin(theta);
//        double z = 4 * cos(phi);
//        addOmni(SCNVector3Make(x, y, z));
//    }

    addOmni(SCNVector3Make(0, 3, 0));
    addOmni(SCNVector3Make(0, 0, 3));
    addOmni(SCNVector3Make(0, 0, -3));
    addOmni(SCNVector3Make(3, 0, 0));
    addOmni(SCNVector3Make(-3, 0, 0));
    /*
     SCNNode *ambientLightNode = [SCNNode node];
     ambientLightNode.light = [SCNLight light];
     ambientLightNode.light.type = SCNLightTypeAmbient;
     ambientLightNode.light.intensity = 5000;
     ambientLightNode.light.color = [UIColor darkGrayColor];
     [scene.rootNode addChildNode:ambientLightNode];
     */
}


@end


@implementation SCNNode (Costelique)

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
