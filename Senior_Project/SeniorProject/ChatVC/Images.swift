//
//  Images.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 8/8/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit

class Images {
    
    class func squareImage(image: UIImage, size: CGFloat) -> UIImage? {
        var cropped: UIImage!
        if (image.size.height > image.size.width)
        {
            let ypos = (image.size.height - image.size.width) / 2
            cropped = self.cropImage(image: image, x: 0, y: ypos, width: image.size.width, height: image.size.height)
        }
        else
        {
            let xpos = (image.size.width - image.size.height) / 2
            cropped = self.cropImage(image: image, x: xpos, y: 0, width: image.size.width, height: image.size.height)
        }
        
        let resized = self.resizeImage(image: cropped, width: size, height: size)
        
        return resized
    }
    
    class func resizeImage( image: UIImage, width: CGFloat, height: CGFloat) -> UIImage? {
        var image = image
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    class func cropImage(image: UIImage, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImage? {
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
//        let imageRef = CGImageCreateWithImageInRect(image.cgImage!, rect)
        let imageRef = image.cgImage?.cropping(to: rect)
        let cropped = UIImage.init(cgImage: imageRef!)
        
        return cropped
    }
}

