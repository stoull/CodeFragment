//
//  ViewController.swift
//  CustomContainerVCTransition
//
//  Created by linkapp on 29/01/2018.
//  Copyright © 2018 hut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if label.superview == nil {
            label.text = title
            label.sizeToFit()
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = true;
            
            let labelCenterXConstraint = NSLayoutConstraint.init(item: view, attribute: .centerX, relatedBy: .equal, toItem: label, attribute: .centerX, multiplier: 1, constant: 0)
            let labelCenterYConstraint = NSLayoutConstraint.init(item: view, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1, constant: 0)
            
            view.addConstraint(labelCenterXConstraint)
            view.addConstraint(labelCenterYConstraint)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

