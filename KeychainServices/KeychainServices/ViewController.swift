//
//  ViewController.swift
//  KeychainServices
//
//  Created by linkapp on 08/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func authenticationWithTouchID(_ sender: Any) {
        if #available(iOS 8.0, *)
        {
//            let dictionary: [String : Any]
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .userPresence, nil)
            if accessControl != nil
            {
//                dictionary[kSecAttrAccessControl as String] = accessControl
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

