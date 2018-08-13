//
//  SnapshotAnimator.swift
//  Karma and destiny
//
//  Created by Олег on 01.12.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

import UIKit.UIView

protocol SnapshotAnimator {
    func animateSnapshot()
}

extension SnapshotAnimator where Self: UIView {
    func animateSnapshot() {
        let view = UIView(frame: self.bounds)
        
        self.addSubview(view)
        view.backgroundColor = UIColor.white
        view.alpha = 0
        UIView.animate(withDuration: 0.1, animations: {
            view.alpha = 1
        }) { (complete) in
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 0
            }) { (completed) in
                view.removeFromSuperview()
            }
        }
    }
}
