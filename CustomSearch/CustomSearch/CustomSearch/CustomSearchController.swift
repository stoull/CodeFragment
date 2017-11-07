//
//  CustomViewController.swift
//  CustomSearch
//
//  Created by linkapp on 07/11/2017.
//  Copyright © 2017 hut. All rights reserved.
//

import UIKit

class CustomSearchController: UISearchController, UISearchBarDelegate {

    private var customSearchBar = CustomSearchBar()
    override public var searchBar: UISearchBar {
        get {
            return customSearchBar
        }
    }
    
    var containerView: UIView!
    
    // 搜索开始时的自定义View
    var customBackGroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置 searchBar
        self.setUpCustomSearchBar()
        
        // 设置 searchController
        self.setUpCustomSearchControllerInfor()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 设置自定义界面
        self.setUpCustomUIElements()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
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
        customSearchBar.delegate = self
    }
    
    // 设置自定 SearchController 信息
    func setUpCustomSearchControllerInfor() {
        self.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        
    }
    
    // 设置自定义界面
    func setUpCustomUIElements() {
        
        customBackGroundView = UIView.init(frame: self.view.frame)
        customBackGroundView.backgroundColor = UIColor.white


        let historyBtn = UIButton.init(frame: CGRect.init(x: 10, y: 80, width: 120.0, height: 44.0))
        historyBtn.setTitle("History", for: UIControlState.normal)
        historyBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        historyBtn.addTarget(self, action: #selector(CustomSearchController.historyButtonDidClick), for: UIControlEvents.touchUpInside)

        let cusSwitch = UISwitch.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 60))
        cusSwitch.center = customBackGroundView.center
        
        customBackGroundView.addSubview(cusSwitch)
        customBackGroundView.addSubview(historyBtn)

        containerView = self.view.subviews.first
        containerView.insertSubview(customBackGroundView, at: 0)
    }
    
    // MARK: - Custom Action Method
    
    // MARK: 按钮点击
    @objc func historyButtonDidClick() {
        print("Search history button did click!")
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        customBackGroundView.removeFromSuperview()
    }

}
