//
//  UIImageView+Extension.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImage(url: URL) {
        
        iTunesAPIClient.downloadData(url: url) { data, response, error in
            
            if error != nil {
                dump(error)
                print(error?.localizedDescription ?? "Unknown error")
            }
            
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.image = image
                }
            }
        }
    }
}


extension UIImageView {
    
    var circularImage: UIImage? {
        var result: UIImage?
        if let image = image {
            let imageDimensions = CGSize(width: min(image.size.width, image.size.height), height: min(image.size.width, image.size.height))
            let imageView = UIImageView(frame: CGRect(origin: self.bounds.origin, size: imageDimensions))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = imageDimensions.width/2
            imageView.layer.masksToBounds = true
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 1)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            imageView.layer.render(in: context)
            result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return result
    }
    
}

