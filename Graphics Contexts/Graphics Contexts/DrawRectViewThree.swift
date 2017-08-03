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
        
        /*
         使用UIGraphicsPushContext存储以前的context并将ctx切换到当前上下文，和UIGraphicsPopContext一起使用
         You can use this function to save the previous graphics state and make the specified context the current context. You must balance calls to this function with matching calls to the UIGraphicsPopContext function.
         */
        
        /*
         UIKit只能在当前上下文中绘图。 在方法UIGraphicsBeginImageContextWithOptions 和 drawRect：中系统已经将创建的上下文切换成前下下文了，所我们可以直接画图。当我们持有一个context参数的时候，必须将该上下文参数转化为当前上下文，就像当前这个方法里面，我们必需要调用 UIGraphicsPushContext 将当前layer的ctx切换为当前的上下文，才能使下面的UIBezierPath绘到当前的layer上面，如果使用Core graphics进行离屏绘制则不需要
         */
        UIGraphicsPushContext(ctx)
        
        let fillPath: UIBezierPath = UIBezierPath.init(rect: CGRect.init(x: 10, y: 10, width: 160, height: 60))
        fillPath.lineWidth = 8.0
        
        UIColor.green.setFill()
        UIColor.red.setStroke()
        
        // 调用UIBezierPath 的 fill , stroke方法
        fillPath.fill()
        fillPath.stroke()
        

        // 离开ctx 切换回到使用以前的Context
        // Removes the current graphics context from the top of the stack, restoring the previous context.
        UIGraphicsPopContext()
    }
}
