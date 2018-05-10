//
//  NavigationController.swift
//  Sparkle Effects Editor
//
//  Created by Олег on 01.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

import UIKit

class TransparentNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
}
