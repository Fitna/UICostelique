//
//  LabelWithBackground.swift
//  Karma and destiny
//
//  Created by Олег on 22.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

import UIKit.UILabel

class LabelWithBackground: UILabel {
    @IBInspectable var background:UIImage?
    
    override func draw(_ rect: CGRect) {
        if let image = background {
            let startPoint = ((self.bounds.size / 2.0) - (image.size / 2.0)).point()
            image.draw(at: startPoint, blendMode: CGBlendMode.normal, alpha: 1.0)
        }
        super.draw(rect)
    }
}
