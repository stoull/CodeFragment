//
//  DrawRectViewSix.swift
//  Graphics Contexts
//
//  Created by linkapp on 03/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import UIKit

class DrawRectViewSix: NSObject {
    
    /* 第六种获取Graphics Contexts的方法
     使用用Graphics Contexts的方法创建Bitmap graphics contexts，这是一种更为底层的方法，需要指定存储空间，颜色空间等信息。注意：使用这种方法创建的context不像其它通过UIKit获得的context，这个context的坐标系还是Quartz的坐标系，这个context也没有存储及切换为当前上下文。
     这种方法可以用来进行离屏绘图，就是都不用将Context渲染屏幕显示，直接导出绘制好的图形。不过在使用这个方式进行离屏绘图前，优先考虑使用CGLayer进行离屏绘图。
     */
    
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
            
            /*
            let drawImage = UIGraphicsGetImageFromCurrentImageContext()
            
             UIGraphicsGetImageFromCurrentImageContext用来获取使用UIGraphicsBeginImageContext方法创建的bitmap图片的上下文绘制的图形。 因为 screenCTX 不是用 UIGraphicsBeginImageContext 创建的bitmap图形，所以获取不到对应的图形，返回的为nil
             You should call this function only when a bitmap-based graphics context is the current graphics context. If the current context is nil or was not created by a call to UIGraphicsBeginImageContext, this function returns nil.
            */
            UIGraphicsPopContext()
            free(imageData)
            return drawImage
        }else {
            return nil
        }
    }
}
