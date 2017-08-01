//
//  DrawRectDemoView.swift
//  Quartz_2D
//
//  Created by Stoull Hut on 29/07/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit
import CoreGraphics

class DrawRectStartViewTwo: UIView {
    
    override func draw(_ rect: CGRect) {
        
        // 使用 Core Graphics 实现绘图
        if  let ctx = UIGraphicsGetCurrentContext() {
            
            let viewFrame = self.bounds
            let rect = CGRect.init(x: 10, y: 10, width: viewFrame.size.width - 20, height: viewFrame.size.height - 20)
            let path = CGPath.init(rect: rect, transform: nil)
            
            ctx.addPath(path)
            
            ctx.setFillColor(UIColor.green.cgColor)
            
            ctx.fillPath()
            
            ctx.setStrokeColor(UIColor.red.cgColor)
            ctx.setLineWidth(8.0)
            ctx.stroke(rect)
        }
        
        //    let rectPath: CGMutablePath = CGMutablePath()
    }
    

    
    
}
