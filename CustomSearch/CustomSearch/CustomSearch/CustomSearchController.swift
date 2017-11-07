//
//  CustomViewController.swift
//  CustomSearch
//
//  Created by linkapp on 07/11/2017.
//  Copyright © 2017 hut. All rights reserved.
//

import UIKit

class CustomSearchController: UISearchController {

    private var customSearchBar = CustomSearchBar()
    override public var searchBar: UISearchBar {
        get {
            return customSearchBar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    init(<#parameters#>) {
//        super.init(searchResultsController: searchResultsController)
//
//    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Method
    
    // 设置searchBar
    func setUpCustomSearchBar() {
        
    }
    
    // 设置自定 SearchController 信息
    func setUpCustomSearchControllerInfor() {
        self.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        
        
        // 设置自定义界面
        self.setUpCustomUIElements()
    }
    
    // 设置自定义界面
    func setUpCustomUIElements() {
        
        let centSwitch = UISwitch.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 60))
        centSwitch.center = self.view.center
        centSwitch.tintColor = UIColor.red
        self.view.addSubview(centSwitch)
    }

}
