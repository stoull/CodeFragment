//
//  DrawRectViewFive.swift
//  Quartz_2D
//
//  Created by linkapp on 03/08/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

class DrawRectViewFive: NSObject {
    
    /*
     第五种获取Graphics Contexts的方法
     UIGraphicsBeginImageContextWithOptions
     快捷创建Bitmap context上下文的方法，并将该新建的上下文存储并设置为当前上下文。它做了相当多的工作，首先是CGContext.init,然后将坐标系转换成UIKit的坐标系，以及将创建的context压入栈并设置为当前上下文的工作。
     
     注意:
     UIGraphicsGetImageFromCurrentImageContext用来获取使用UIGraphicsBeginImageContext方法创建的bitmap图片的上下文绘制的图形。 因为 screenCTX 不是用 UIGraphicsBeginImageContext 创建的bitmap图形，所以获取不到对应的图形，返回的为nil
     You should call this function only when a bitmap-based graphics context is the current graphics context. If the current context is nil or was not created by a call to UIGraphicsBeginImageContext, this function returns nil.
     */
    public func drawImage() -> UIImage? {
        
        let imageSize: CGSize = CGSize.init(width: 200.0, height: 200.0)
        let scale = UIScreen.main.scale
        
        // 创建一个画布，并将该上下文件切换为当前上下文
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
//        UIGraphicsBeginImageContext(<#T##size: CGSize##CGSize#>)
        
        // 获取创建的画布
        let ctx = UIGraphicsGetCurrentContext()
        
        let path = UIBezierPath.init(ovalIn:CGRect.init(x: 0.0, y: 0.0, width: imageSize.width, height: imageSize.height))
        UIColor.red.setFill()
        ctx?.setFillColor(UIColor.red.cgColor)
        path.fill()
        
        // 把画导出为 UIImage 格式，怎么导出为纸质的！
        let drawImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return drawImage
    }
}
