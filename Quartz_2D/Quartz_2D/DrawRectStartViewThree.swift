//
//  DrawRectStartViewThree.swift
//  Quartz_2D
//
//  Created by Stoull Hut on 01/08/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

class MyLayerDelegate: NSObject {
    func draw(_ layer: CALayer, in ctx: CGContext) {
        
        UIGraphicsPushContext(ctx)
        
        let fillPath: UIBezierPath = UIBezierPath.init(rect: CGRect.init(x: 10, y: 10, width: 160, height: 60))
        fillPath.lineWidth = 8.0
        
        UIColor.green.setFill()
        UIColor.red.setStroke()
        
        fillPath.fill()
        fillPath.stroke()
        
        UIGraphicsPopContext()
    }
}

class DrawRectStartViewThree: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
