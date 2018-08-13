//
//  ScrollViewWithHeader.swift
//  Karma and destiny
//
//  Created by Олег on 17.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

import UIKit.UIScrollView

fileprivate extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class ScrollViewWithHeader: UIScrollView {
    let imageView = UIImageView()
    var imageCentered = false
    var imageAlignment: UIViewContentMode = .center
    
    @IBInspectable var headerImage: UIImage? {
        didSet {
            imageView.image = headerImage
        }
    }
    
    @IBInspectable var headerHeight: CGFloat = 0 {
        didSet {
            contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0)
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.red
        imageView.clipsToBounds = true
        insertSubview(imageView, at: 0)
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            parentViewController?.automaticallyAdjustsScrollViewInsets = false
        }
        
        contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0)
    }
    
    override var contentOffset: CGPoint {
        didSet {
            guard let image = headerImage else {
                return
            }
            
            var headerSize = image.size * (self.bounds.width / image.size.width)
            if imageAlignment == .bottom && headerSize.height < -contentOffset.y {
                headerSize.height = -contentOffset.y
            }
            
            if imageAlignment == .center {
                headerSize.height = -contentOffset.y
            }
            
            var y: CGFloat = -headerSize.height
            
            if imageAlignment == .top {
                y = contentOffset.y
            }
            
            imageView.frame = CGRect(x: 0,
                                     y: y,
                                     width: self.frame.width,
                                     height: headerSize.height)
        }
    }
}

