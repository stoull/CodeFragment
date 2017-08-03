//
//  DrawRectDemoView.swift
//  Quartz_2D
//
//  Created by Stoull Hut on 28/07/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

class DrawRectViewOne: UIView {
    /*在这个 draw 方法中, UIKit做了所有事情，获取Graphics Contexts，并将该上下文件切换为当前上下文，转换对应的坐标，将我们用UIKit做操作转成CoreGraphics的接口画上去。
    下面在UIView上画一个矩形，填充并描边，根本就不要`import CoreGraphics`，直接用UIKit就可以。*/
    override func draw(_ rect: CGRect) {
        
        let viewFrame: CGRect = self.bounds
        let fileRect = CGRect.init(x: 10, y: 10, width: viewFrame.size.width - 20, height: viewFrame.size.height - 20)
        
        let fillPath: UIBezierPath = UIBezierPath.init(rect: fileRect)
        fillPath.lineWidth = 8.0
        
        UIColor.green.setFill()
        UIColor.red.setStroke()
        
        // 调用UIBezierPath 的 fill , stroke方法
        fillPath.fill()
        fillPath.stroke()
    }
    
    // 注：关于drawRect内存使用的问题 http://bihongbo.com/2016/01/03/memoryGhostdrawRect/
}
