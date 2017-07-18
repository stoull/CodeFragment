//
//  ViewController.swift
//  TableView
//
//  Created by linkapp on 18/07/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView = UITableView.init()     // provide initial value 提供初始值
    var refreshControl: UIRefreshControl!               // declare I don't want provide initial value, I'll control by myself  表示我现在不想提供初始值，我会在程序中控制
    
    lazy var segmentControler: UISegmentedControl = {   // Use the lazy 使用懒加载
        let segmentControl = UISegmentedControl.init(items: ["One", "Tow"])
        segmentControl.tintColor = UIColor.blue
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlStateDidChange), for: .valueChanged)
        return segmentControl
    }()
    
    let screenSize: CGSize = UIScreen.main.bounds.size
    let CellReuseIdentifier: String = "TvCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 0.5, green: 0.3, blue: 0.4, alpha: 1.0)
        
        // Setup Tableview
        self.tableView = self.setUpTableView()
        
        view.addSubview(self.tableView)
        
        setUpRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show the navigaiton title
        let vcCount = navigationController?.viewControllers.count
        if vcCount != nil {
            title = String.init(format: "TableView %ld", vcCount!)
        }else {
            title = "TableView"
        }
    }
    
    // setup the tableView
    func setUpTableView() -> UITableView{
        tableView.frame = CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: CellReuseIdentifier)
        return tableView
    }
    
    func setUpRefreshControl() {
        refreshControl = UIRefreshControl.init()
        refreshControl.addTarget(self, action: #selector(refreshControlStatusDidChange), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func segmentControlStateDidChange() {
        print("SegmentControllerDidSelected")
    }
    
    func refreshControlStatusDidChange(refreshCR: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    // UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 3
        }else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier, for: indexPath)
        var str: String = "Swift "
        str += String.init(format: "Section: %ld   ", indexPath.section)
        str += String.init(format: "Row: %ld", indexPath.row)
        cell.textLabel?.text = str
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ViewController.init()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

