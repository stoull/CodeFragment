//
//  DrawRectStartViewThree.swift
//  Quartz_2D
//
//  Created by Stoull Hut on 01/08/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

class MyLayerDelegate: NSObject, CALayerDelegate{
    
    // CALayerDelegate
    func draw(_ layer: CALayer, in ctx: CGContext) {
        
        UIGraphicsPushContext(ctx)
        
        let fillPath: UIBezierPath = UIBezierPath.init(rect: CGRect.init(x: 10, y: 10, width: 160, height: 60))
        fillPath.lineWidth = 8.0
        
        UIColor.green.setFill()
        UIColor.red.setStroke()
        
        // 调用UIBezierPath 的 fill , stroke方法
        fillPath.fill()
        fillPath.stroke()
        
        UIGraphicsPopContext()
    }
}
