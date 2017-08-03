//
//  DrawRectViewFive.swift
//  Quartz_2D
//
//  Created by linkapp on 03/08/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

class DrawRectViewFive: NSObject {
    
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
