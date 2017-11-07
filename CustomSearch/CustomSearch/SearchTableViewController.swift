//
//  SearchTableViewController.swift
//  CustomSearch
//
//  Created by linkapp on 07/11/2017.
//  Copyright © 2017 hut. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var countriesArray: Array<String>?
    var customSearchContorller: CustomSearchController!
    
    var searchResultVC: SearchResultViewController!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update navigationBar UI
        self.updateTheNavigationBar()
        
        // Setup custom search Controller
        self.setupSearchController()
        searchResultVC = SearchResultViewController()
        customSearchContorller = CustomSearchController.init(searchResultsController: searchResultVC)
        self.tableView.tableHeaderView = customSearchContorller.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupSearchController()
        self.setupTableView()
        
        // Load the Tableview Data
        self.loadTheTestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let countries = countriesArray {
            return countries.count
        }else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        if let countryName = countriesArray?[indexPath.row] {
            cell.textLabel?.text = countryName
        }else {
            cell.textLabel?.text = "Unkonw Country"
        }
        return cell
    }

    // MARK: - Custom functions
    
    // MARK: 更新Tableview数据
    func loadTheTestData() {
        self.countriesArray = self.getListOfCountries()
        tableView.reloadData()
    }
    
    // MARK: 更新NavigaionBar的显示
    func updateTheNavigationBar() {
        self.title = "World Countries"
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: 设置搜索控制器
    func setupSearchController() {
        searchResultVC = SearchResultViewController()
        customSearchContorller = CustomSearchController.init(searchResultsController: searchResultVC)
        customSearchContorller.searchResultsUpdater = self
        customSearchContorller.delegate = self
    }
    
    // MARK: 设置TableView
    func setupTableView() {
        
        self.tableView.tableHeaderView = customSearchContorller.searchBar
    }
    
    // MARK: 获取数据文件
    func getListOfCountries() -> Array<String> {
        // Search the file path of countries file
        let pathToConutriesFile = Bundle.main.path(forResource: "countries", ofType: "txt");
        
        if let filePath = pathToConutriesFile {
            // Read the content in the special file
            guard let countriesString = try? String.init(contentsOfFile: filePath, encoding: String.Encoding.utf8) else {
                return Array()
            }
            
            // Convert the string into the separeted country
            let dataArray: Array<String> = countriesString.components(separatedBy: CharacterSet.init(charactersIn: "\n"))
            
            return dataArray
        }else {
            return Array()
        }
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // MARK: - UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
    }
}
