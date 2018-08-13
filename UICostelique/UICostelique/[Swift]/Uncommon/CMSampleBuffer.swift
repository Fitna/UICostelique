//
//  CMSampleBuffer.swift
//  ScreenStitch
//
//  Created by Олег on 10.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import UIKit

import CoreMedia.CMSampleBuffer
extension CMSampleBuffer {

    func size() -> CGSize {
        if let imageBuffer = CMSampleBufferGetImageBuffer(self) {
            return CGSize(width: CVPixelBufferGetWidth(imageBuffer), height: CVPixelBufferGetHeight(imageBuffer))
        } else {
            abort()
        }
    }
}
