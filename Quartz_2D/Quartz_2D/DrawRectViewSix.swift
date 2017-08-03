//
//  DrawRectViewSix.swift
//  Quartz_2D
//
//  Created by linkapp on 03/08/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

class DrawRectViewSix: CALayer {
    
    override func render(in ctx: CGContext) {
        
        
        let layerRect: CGRect = self.bounds;
        
        // 使用UIGraphicsPushContext切换到ctx
        UIGraphicsPushContext(ctx)
        
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
        ctx.fillPath()
        
        // 离开ctx 切换回到使用以前的Context
        UIGraphicsPopContext()
    }
}
