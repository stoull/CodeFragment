//
//  DrawRectDemoView.swift
//  Quartz_2D
//
//  Created by Stoull Hut on 29/07/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit
import CoreGraphics

class DrawRectDemoView: UIView {

    
    override func draw(_ rect: CGRect) {
        let currentContext: CGContext? = UIGraphicsGetCurrentContext()
        
        if  let ctx = UIGraphicsGetCurrentContext() {
            ctx.setStrokeColor(UIColor.red.cgColor)
            
            ctx.setLineWidth(2.0)
        }
        
        //    let rectPath: CGMutablePath = CGMutablePath()
    }
    

    
    
}
