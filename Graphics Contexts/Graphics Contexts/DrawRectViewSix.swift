//
//  DrawRectViewSix.swift
//  Graphics Contexts
//
//  Created by linkapp on 03/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import UIKit

class DrawRectViewSix: NSObject {
    func getDrawImage() -> UIImage? {
        
        let imageSize: CGSize = CGSize.init(width: 200.0, height: 200.0)
        let scale = UIScreen.main.scale
        let imageRect = CGRect.init(x: 10, y: 100.0, width: imageSize.width - 10, height: imageSize.height)
        
//        let imageData = calloc( Int(imageSize.width) * Int(imageSize.height) * 8, MemoryLayout<UInt8>.size)
//        GLubyte *imageData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
        
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let screentContext = CGContext.init(data: nil, width: Int(imageRect.width), height: Int(imageRect.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        // 这个时候如果要在这个新建的画布上面绘图的话，就需要用到 UIGraphicsPushContext 方法了
        if let screenCTX = screentContext {
            
            screenCTX.scaleBy(x: scale, y: scale)
            
            // 将 screenCTX 设置为当前上下文, UIKit只能在当前上下文中绘图,所以下面使用的 UIBezierPath 的绘制方法才能将图形绘制到screenCTX上下文中
            UIGraphicsPushContext(screenCTX)
            
            let bPath = UIBezierPath.init(ovalIn:CGRect.init(x: 0.0, y: 0.0, width: imageSize.width, height: imageSize.height))
            UIColor.red.setFill()
            bPath.fill()
            
            screenCTX.move(to: CGPoint.init(x: 120.0, y: 80.0))
            screenCTX.addLine(to: CGPoint.init(x: imageSize.width - 120.0, y: 80.0))
            screenCTX.setLineWidth(12.0)
            screenCTX.setStrokeColor(UIColor.blue.cgColor)
            screenCTX.strokePath()
            
            let drawImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsPopContext()
            
            return drawImage
        }else {
            return nil
        }
    }
}
