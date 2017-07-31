//
//  ViewController.swift
//  AttributedStrings
//
//  Created by Stoull Hut on 31/07/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var attributeStringLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // string you want to become attribute
        let text = "Testing Attributed Strings"
        let attributeStr = NSMutableAttributedString.init(string: text)
        
        let oneAttribute: [String : Any] = [NSForegroundColorAttributeName : UIColor.gray,
                                            NSBackgroundColorAttributeName : UIColor.white,
                                            NSUnderlineStyleAttributeName: 1,
                                            NSFontAttributeName : UIFont.systemFont(ofSize: 16)]
        let twoAttribute: [String : Any] = [NSForegroundColorAttributeName : UIColor.red,
                                            NSBackgroundColorAttributeName: UIColor.yellow,
                                            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 22)]
        let threeAttribute: [String : Any] = [NSForegroundColorAttributeName: UIColor.green,
                                              NSBackgroundColorAttributeName: UIColor.blue,
                                              NSFontAttributeName: UIFont.systemFont(ofSize: 44)]
        
        attributeStr.addAttributes(oneAttribute, range: NSRange(location: 0, length: 8))
        attributeStr.addAttributes(twoAttribute, range: NSRange(location: 8, length: 11))
        attributeStr.addAttributes(threeAttribute, range: NSRange(location: 19, length: 7))
        
        self.attributeStringLabel.attributedText = attributeStr
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

