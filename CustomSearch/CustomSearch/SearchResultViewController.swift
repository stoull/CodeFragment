//
//  SearchResultViewController.swift
//  CustomSearch
//
//  Created by linkapp on 07/11/2017.
//  Copyright © 2017 hut. All rights reserved.
//

import UIKit

let resultCellIdentifier = "resultCellIdentifier"

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    var resultArray: Array<Any>?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupResultView();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Initialization Method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    // MARK: - Private Method
    
    // MARK: 设置tableview 等自定义元素
    func setupResultView() {
        print("Setup ResultView ......")
        tableView = UITableView.init(frame: self.view.frame)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView.register(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: resultCellIdentifier)
        
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let noNilArray = resultArray {
            return noNilArray.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCellIdentifier, for: indexPath)
        if let resultString = resultArray?[indexPath.row] as? String {
            cell.textLabel?.text = resultString
        }else {
            cell.textLabel?.text = "Unkonw result cell"
        }
        return cell
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
