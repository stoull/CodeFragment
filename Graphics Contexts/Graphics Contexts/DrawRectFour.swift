//
//  DrawRectViewFour.swift
//  Quartz_2D
//
//  Created by linkapp on 03/08/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

class DrawRectViewFour: CALayer {

    /*
     第四种获取Graphics Contexts的方法
     
     CALayer: draw(in ctx: CGContext)
     
     */
    
    override func draw(in ctx: CGContext) {
        
        let layerRect: CGRect = self.bounds;

        let padding: CGFloat = 20.0
        ctx.move(to: CGPoint.init(x: layerRect.origin.x + padding, y: layerRect.origin.y + padding))
        ctx.addLine(to: CGPoint.init(x: layerRect.size.width - padding, y: layerRect.origin.y + padding))
        ctx.addLine(to: CGPoint.init(x: layerRect.size.width - padding, y: layerRect.size.height - padding))
        ctx.addLine(to: CGPoint.init(x: layerRect.origin.x + padding, y: layerRect.size.height - padding))
        ctx.closePath()
        
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.setFillColor(UIColor.blue.cgColor)
        ctx.setLineWidth(6.0)

        ctx.strokePath()
    }
}
