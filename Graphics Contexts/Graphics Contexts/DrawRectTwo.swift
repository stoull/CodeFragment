//
//  DrawRectDemoView.swift
//  Quartz_2D
//
//  Created by Stoull Hut on 29/07/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit
import CoreGraphics

class DrawRectViewTwo: UIView {
    
    override func draw(_ rect: CGRect) {
        
        // 使用 Core Graphics 实现绘图
        
        /*
         
         第二种获取Graphics Contexts的方法
         
         获取当前上下文的工具：
         UIGraphicsGetCurrentContext()
         使用这个方法特别方便的获取当前的上下文。只要你或系统通过任何方式设置过当前上下文，像在UIView的draw(_ rect: CGRect)方法中，UIGraphicsBeginImageContextWithOptions方法后，或UIGraphicsPushContext(screenCTX)后，可以特别方便的获取当前的context。获取到context之后，就不仅可以使用UIKit进行绘图，还可以直接调用Quartz的绘图方法了。
         当前上下文的默认值为nil。如果先前没有使用UIView进行绘制动作，或没有UIGraphicsPushContext，即context的存储栈里面压入任何的context，调用此方法将返回nil。
         
         */
        
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
