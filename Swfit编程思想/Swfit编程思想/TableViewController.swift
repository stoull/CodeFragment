//
//  TableViewController.swift
//  Swfit编程思想
//
//  Created by Stoull Hut on 30/07/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit
import Foundation

struct ListItem {
    var title : String = ""
    var icon: UIImage?
    var url: URL!
    
    static func listItemsFromJSONData(jsonData: Data) -> NSArray? {
        let jsonItems: NSArray? = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        let listItems = NSMutableArray()
        if jsonItems != nil {
            for itemDic in jsonItems! {
                guard let itemInfor = itemDic as? NSDictionary else {
                    assert(false, "JSON data is not NSDictionary")
                    return nil
                }
                var item: ListItem = ListItem()
                item.title = itemInfor.object(forKey: "title") as! String
                item.icon = UIImage.init(named: itemInfor.object(forKey: "name") as! String)
                item.url = URL(string: itemInfor.object(forKey: "url") as! String)
                listItems.add(item)
            }
        }
        
        return listItems
    }
}

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    /*
     +(NSArray*)listItemsFromJSONData:(NSData*)jsonData {
     NSArray* itemsDescriptors = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
     NSMutableArray* items = [NSMutableArray new];
     for (NSDictionary* itemDesc in itemsDescriptors) {
     ListItem* item = [ListItem new];
     item.icon = [UIImage imageNamed:itemDesc[@"icon"]];
     item.title = itemDesc[@"title"];
     item.url = [NSURL URLWithString:itemDesc[@"title"]];
     [items addObject:item];
     }
     return [items copy];
     }
     */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
