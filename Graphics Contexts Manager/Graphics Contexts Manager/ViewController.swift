//
//  ViewController.swift
//  Graphics Contexts Manager
//
//  Created by linkapp on 04/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Context 的切换及存储示例
        let XPadding: CGFloat = 44.0
        let YPadding: CGFloat = 90.0
        let imageView = UIImageView.init(frame: CGRect.init(x: XPadding, y: YPadding, width: 200.0, height: 200.0))

        let drewer = ManageContext()
        drewer.view = self.view
        if let image = drewer.exampleCGContextSaveGState() {
            imageView.image = image
        }

        view.addSubview(imageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

