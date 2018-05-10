//
//  SceneKit.swift
//  ScreenStitch
//
//  Created by Олег on 10.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import SceneKit.ModelIO

extension SCNVector3 {
    fileprivate func sqare(_ float: Float) -> Float {
        return float * float
    }
    func distance(toVector vector: SCNVector3) -> Float {
        return sqrtf(sqare(self.x - vector.x) + sqare(self.y - vector.y) + sqare(self.z - vector.z))
    }
}
