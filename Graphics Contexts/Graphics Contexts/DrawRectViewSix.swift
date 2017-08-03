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

        let bitmapBytesPerRow: Int = Int(imageSize.width) * 4
        let bitmapByteCount: Int = bitmapBytesPerRow * Int(imageSize.height)
        let imageData: UnsafeMutableRawPointer! = calloc(bitmapByteCount, bitmapBytesPerRow)
        
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let screentContext = CGContext.init(data: imageData,
                                            width: Int(imageSize.width),
                                            height: Int(imageSize.height),
                                            bitsPerComponent: 8,
                                            bytesPerRow: bitmapBytesPerRow,
                                            space: colorSpace,
                                            bitmapInfo: bitmapInfo.rawValue)

        if let screenCTX = screentContext {
            
            // 将 screenCTX 设置为当前上下文, UIKit只能在当前上下文中绘图,所以下面使用的 UIBezierPath 的绘制方法才能将图形绘制到screenCTX上下文中
            UIGraphicsPushContext(screenCTX)
            
            let bPath = UIBezierPath.init(ovalIn:CGRect.init(x: 0.0, y: 0.0, width: imageSize.width, height: imageSize.height))
            UIColor.red.setFill()
            bPath.fill()
            
            guard let drawImageRef = screenCTX.makeImage() else {
                return nil
            }
            
            let drawImage = UIImage.init(cgImage: drawImageRef)
            
//            let drawImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsPopContext()
            
            return drawImage
        }else {
            return nil
        }
    }
}
