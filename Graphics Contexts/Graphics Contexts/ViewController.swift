//
//  ViewController.swift
//  Graphics Contexts
//
//  Created by linkapp on 03/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 定义一个类，实现 CALayerDelegate 的代理方法
    let myLayerDelegate = MyLayerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        /* 主要是 Graphics Contexts 的理解。Graphics Contexts 是一个你要开始做图像处理的环境。如在PhotoShop中如果你要开始用画笔画一张图画，你就要新建一个画布（其实你看到的是画布上面的一张透明的图像），你需要指定画布的大小,颜色模式,分辨率等等。新建好之后就有一个空白的图像，这个时候工具栏的工具都可以用了（如矩形选框，画笔，文字等）。Graphics Contexts 就是这个新建的的空白图像，所有对图片的处理动作都是在这个新建的画布中。而所有的Core Craphics都在Graphics Contexts上进行处理，所以对Graphics Contexts学习主要有。
         1. 如何新建或获得Graphics Contexts（画布）是需要我们好好学习的，不然一切Core Craphics功能都无从开始。
         2. 这些Graphics Contexts（画布）的状态如何存储，画布之间如何切换，这些在绘图中也是必需要的技巧。
         2. 还有就是如存存储画布以及不画布中导出不同类型的格式（PDF文件，Bitmap图像，屏幕显示等）
         
         */
        
        
        /*
         导出画布（Graphics Contexts）的图像：
         
         UIKit:
         UIGraphicsGetImageFromCurrentImageContext
         UIGraphicsGetImageFromCurrentImageContext用来获取使用UIGraphicsBeginImageContext方法创建的bitmap图片的上下文绘制的图形。 因为 screenCTX 不是用 UIGraphicsBeginImageContext 创建的bitmap图形，所以获取不到对应的图形，返回的为nil
         You should call this function only when a bitmap-based graphics context is the current graphics context. If the current context is nil or was not created by a call to UIGraphicsBeginImageContext, this function returns nil.
         
         
         UIView: setNeedsDisplay() setNeedsDisplayInRect()
         /*
        You should use this method to request that a view be redrawn only when the content or appearance of the view change. If you simply change the geometry of the view, the view is typically not redrawn.
         */
         
         
         CALayer: setNeedsDisplay()
         
         Calling this method causes the layer to recache its content. This results in the layer potentially calling either the displayLayer: or drawLayer:inContext: method of its delegate. The existing content in the layer’s contents property is removed to make way for the new content.
         
         Core Graphics:
         CGContext: makeImage()方法
         */
        
        
        // 第一种获取Graphics Contexts的方法
        let drawRectView: DrawRectOne = DrawRectOne()
        let screenWidth = UIScreen.main.bounds.size.width
        let XPadding: CGFloat = 44.0
        let YPadding: CGFloat = 90.0
        drawRectView.backgroundColor = UIColor.gray
        drawRectView.frame = CGRect.init(x: XPadding, y: YPadding, width: screenWidth - 2 * XPadding, height: 120.0)
        view.addSubview(drawRectView)
        
        
        
        // 第二种获取Graphics Contexts的方法
        //        let drawRectView: DrawRectTwo = DrawRectViewTwo()
        //        let screenWidth = UIScreen.main.bounds.size.width
        //        let XPadding: CGFloat = 44.0
        //        let YPadding: CGFloat = 90.0
        //        drawRectView.backgroundColor = UIColor.gray
        //        drawRectView.frame = CGRect.init(x: XPadding, y: YPadding, width: screenWidth - 2 * XPadding, height: 120.0)
        //        view.addSubview(drawRectView)
        
        
        
        // 第三种获取Graphics Contexts的方法
//        let myLayer = CALayer()
//        myLayer.backgroundColor = UIColor.gray.cgColor
//        let screenWidth = UIScreen.main.bounds.size.width
//        let XPadding: CGFloat = 44.0
//        let YPadding: CGFloat = 90.0
//        myLayer.frame = CGRect.init(x: XPadding, y: YPadding, width: screenWidth - 2 * XPadding, height: 120.0);
//        myLayer.delegate = myLayerDelegate
//        myLayer.setNeedsDisplay()
//        view.layer.addSublayer(myLayer)
        
        // 每四种获取Graphics Contexts的方法
//        let myLayer = DrawRectFour()
//        myLayer.backgroundColor = UIColor.gray.cgColor
//        let screenWidth = UIScreen.main.bounds.size.width
//        let XPadding: CGFloat = 44.0
//        let YPadding: CGFloat = 90.0
//        myLayer.frame = CGRect.init(x: XPadding, y: YPadding, width: screenWidth - 2 * XPadding, height: 120.0);
//        myLayer.setNeedsDisplay()
//        view.layer.addSublayer(myLayer)
        
        
        
        // 第五种获取Graphics Contexts的方法
        //        let XPadding: CGFloat = 44.0
        //        let YPadding: CGFloat = 90.0
        //        let imageView = UIImageView.init(frame: CGRect.init(x: XPadding, y: YPadding, width: 200.0, height: 200.0))
        //
        //        let drewer = DrawRectFive()
        //        if let image = drewer.drawImage() {
        //            imageView.image = image
        //        }
        //
        //        view.addSubview(imageView)
        
        
        // 第六种获取Graphics Contexts的方法
//        let XPadding: CGFloat = 44.0
//        let YPadding: CGFloat = 90.0
//        let imageView = UIImageView.init(frame: CGRect.init(x: XPadding, y: YPadding, width: 200.0, height: 200.0))
//
//        let drewer = DrawRectSix()
//        if let image = drewer.getDrawImage() {
//            imageView.image = image
//        }
//
//        view.addSubview(imageView)
        
        
        
        // 第七种获取Graphics Contexts的方法 UIGraphicsImageRenderer
        
//        let XPadding: CGFloat = 44.0
//        let YPadding: CGFloat = 90.0
//        let imageView = UIImageView.init(frame: CGRect.init(x: XPadding, y: YPadding, width: 200.0, height: 200.0))
//        
//        let drewer = DrawRectSeven()
//        if let image = drewer.getDrawImage() {
//            imageView.image = image
//        }
//        
//        view.addSubview(imageView)
    }
}

