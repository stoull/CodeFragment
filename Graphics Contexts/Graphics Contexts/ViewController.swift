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
        
        
        
        // 每一种获取Graphics Contexts的方法
        //        let drawRectView: DrawRectViewOne = DrawRectViewOne()
        //        let screenWidth = UIScreen.main.bounds.size.width
        //        let XPadding: CGFloat = 44.0
        //        let YPadding: CGFloat = 90.0
        //        drawRectView.backgroundColor = UIColor.gray
        //        drawRectView.frame = CGRect.init(x: XPadding, y: YPadding, width: screenWidth - 2 * XPadding, height: 120.0)
        //        view.addSubview(drawRectView)
        
        
        
        // 每二种获取Graphics Contexts的方法
        //        let drawRectView: DrawRectViewTwo = DrawRectViewTwo()
        //        let screenWidth = UIScreen.main.bounds.size.width
        //        let XPadding: CGFloat = 44.0
        //        let YPadding: CGFloat = 90.0
        //        drawRectView.backgroundColor = UIColor.gray
        //        drawRectView.frame = CGRect.init(x: XPadding, y: YPadding, width: screenWidth - 2 * XPadding, height: 120.0)
        //        view.addSubview(drawRectView)
        
        
        
        // 每三种获取Graphics Contexts的方法
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
//        let myLayer = DrawRectViewFour()
//        myLayer.backgroundColor = UIColor.gray.cgColor
//        let screenWidth = UIScreen.main.bounds.size.width
//        let XPadding: CGFloat = 44.0
//        let YPadding: CGFloat = 90.0
//        myLayer.frame = CGRect.init(x: XPadding, y: YPadding, width: screenWidth - 2 * XPadding, height: 120.0);
//        myLayer .setNeedsDisplay()
//        view.layer.addSublayer(myLayer)
        
        
        
        // 每五种获取Graphics Contexts的方法
        //        let XPadding: CGFloat = 44.0
        //        let YPadding: CGFloat = 90.0
        //        let imageView = UIImageView.init(frame: CGRect.init(x: XPadding, y: YPadding, width: 200.0, height: 200.0))
        //
        //        let drewer = DrawRectViewFive()
        //        if let image = drewer.drawImage() {
        //            imageView.image = image
        //        }
        //
        //        view.addSubview(imageView)
        
        
        // 每六种获取Graphics Contexts的方法
        let XPadding: CGFloat = 44.0
        let YPadding: CGFloat = 90.0
        let imageView = UIImageView.init(frame: CGRect.init(x: XPadding, y: YPadding, width: 200.0, height: 200.0))

        let drewer = DrawRectViewSix()
        if let image = drewer.getDrawImage() {
            imageView.image = image
        }

        view.addSubview(imageView)
        
        
        
        
        
        
        
        
        
        // Context 的切换及存储示例
//        let XPadding: CGFloat = 44.0
//        let YPadding: CGFloat = 90.0
//        let imageView = UIImageView.init(frame: CGRect.init(x: XPadding, y: YPadding, width: 200.0, height: 200.0))
//
//        let drewer = ManageContext()
//        drewer.view = self.view
//        if let image = drewer.exampleCGContextSaveGState() {
//            imageView.image = image
//        }
//
//        view.addSubview(imageView)
        
        
        
    }

    @IBAction func showCurrentScreen(_ sender: Any) {
        let screenSize = UIScreen.main.bounds.size
        let screenImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        let drewer = ManageContext()
        drewer.view = self.view
        if let image = drewer.exampleUIGraphicsBeginImageContext() {
            screenImageView.image = image
        }
        
        view.addSubview(screenImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

