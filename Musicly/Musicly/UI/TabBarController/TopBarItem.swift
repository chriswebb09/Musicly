//
//  TopBarItem.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class CustomTabBarItem: UIView {
    
    var iconView: UIImageView!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(item: UITabBarItem) {
        
        guard let image = item.image else {
            fatalError("add images to tabbar items")
        }
        
        // create imageView centered within a container
        iconView = UIImageView(frame: CGRect(x: (self.frame.width-image.size.width)/2, y: (self.frame.height-image.size
            .height)/2, width: self.frame.width, height: self.frame.height))
        
        iconView.image = image
        iconView.sizeToFit()
        
        self.addSubview(iconView)
    }
    
}

//class TopBarItem: UIView {
//    
//    var titleLabel: UILabel!
//    var imageView: UIImageView!
//    
//    func makeLabel() {
//        titleLabel = UILabel(frame: CGRect.zero)
//        titleLabel.textAlignment = .center
//        titleLabel.numberOfLines = 0
//        titleLabel.font = UIFont(name: "Helvetica", size: 10)
//        addSubview(titleLabel)
//    }
//    
//    func makeImageView(icon: UIImage) {
//        imageView = UIImageView(frame: CGRect.zero)
//        imageView.image = icon
//        addSubview(imageView)
//    }
//}
