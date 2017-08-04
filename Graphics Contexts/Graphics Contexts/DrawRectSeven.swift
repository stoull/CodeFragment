//
//  DrawRectSeven.swift
//  Graphics Contexts
//
//  Created by linkapp on 04/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import UIKit


/*
 第七种获取Graphics Contexts的方法
 
 UIGraphicsImageRenderer  iOS 10+
 Apple document:
 https://developer.apple.com/documentation/uikit/uigraphicsimagerenderer
 
 Drawing into a Core Graphics context with UIGraphicsImageRenderer:
 https://www.hackingwithswift.com/read/27/3/drawing-into-a-core-graphics-context-with-uigraphicsimagerenderer
 
 
 A graphics renderer for creating Core Graphics-backed images.
 
 */


class DrawRectSeven: NSObject {
    func getDrawImage() -> UIImage? {
        
        let imageSize = CGSize.init(width: 200, height: 200)
        let renderFormat = UIGraphicsImageRendererFormat.default() // *
        renderFormat.opaque = false
        
        let render = UIGraphicsImageRenderer.init(size: imageSize, format: renderFormat)
        
        // 这里的 ctx 是 UIGraphicsImageRendererContext 类, 这个类有一个CGContext属性，这个就有点像UIKit对CGContext类更高的封装，获取图片和导出图片数据也更方便.
        let drawImage = render.image { (ctx) in
            UIColor.darkGray.setStroke()
            ctx.stroke(render.format.bounds)
            UIColor(colorLiteralRed: 158/255, green: 215/255, blue: 245/255, alpha: 1).setFill()
            ctx.fill(CGRect(x: 1, y: 1, width: 140, height: 140))
        }
        
        return drawImage
    }
}
