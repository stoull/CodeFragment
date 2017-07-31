//
//  TableViewController.swift
//  Thinking in Swift
//
//  Created by Stoull Hut on 30/07/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import UIKit

/*
 READ ME
 
 本项目主要体验下Swift的严谨和安全性。主要对可选类型，对象有无值，对象是否是对应的类型，异常，类型转换，是否是初始等等作些思考。
 
 主要参考这一篇的学习记录
 http://alisoftware.github.io/swift/2015/09/06/thinking-in-swift-1/
 

 */


struct ListItem {
    var title : String = ""
    var icon: UIImage?
    var url: URL!
    
    // 第一次解析JSON数据 （初学者）
    
    /*
     /*
     What's wrong in the under code:
     using implicitly-unwrapped optionals (value!), force-casts (value as! String) and force-try (try!) everywhere.
     到处使用隐式解析可选类型（value!），强制转型（value as! String）和强制使用try（try!）
     */
     
     
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
    */
    
    // 第二次解析JSON数据
    
    /*
     Keep in mind:
     1. 可选类型就是让你考虑当值为nil时你要怎么处理
     2. 不要随便强制解包，除非你知道那里面一定有值，否则一定要考虑当为nil的情况
        在OC中对nil根本就没有严谨过
     
     使用可选解包 if let x = optional
     用 as? 代替 as! 这样如查类型转换失败，则会返回nil
     使用 try? 代替 try! 当执行发生失败的时候， 会返回nil
    
     */
    
    /*
    static func listItemsFromJSONData(jsonData: Data?) -> NSArray? {
        if let noNilJSONData = jsonData {
            let jsonDescrible = try? JSONSerialization.jsonObject(with: noNilJSONData, options: JSONSerialization.ReadingOptions.allowFragments)
            if jsonDescrible != nil {
                if let jsonArray = jsonDescrible as? Array<NSDictionary> {
                    let items = NSMutableArray()
                    for jsonDic in jsonArray {
                        var item = ListItem()
                        if let titleString = jsonDic.object(forKey: "title") as? String {
                            item.title = titleString
                        }
                        
                        if let imageStr = jsonDic.object(forKey: "name") as? String {
                            item.icon = UIImage(named: imageStr)
                        }
                        
                        if let urlStr = jsonDic.object(forKey: "url") as? String {
                            item.url = URL.init(string: urlStr)
                        }
                        
                        items.add(item)
                    }
                    return items
                }else {
                    return nil
                }
                
            }else {
                return nil
            }
        }else {
            return nil
        }

    }
    */
    
    // 第三次解析JSON数据
    
    /*
     上面那群代码，被别人称作判决金字塔，要多高有多高。简化机制：
     1. 将多个 if let 合并成一个，if let x = opX, let y = opY
     2. 使用 guard 语句
     */
    
    static func listItemsFromJSONData(jsonData: Data?) -> Array<ListItem> {
        guard let noNilJSONData = jsonData,
            let jsonDescrible = try? JSONSerialization.jsonObject(with: noNilJSONData, options: JSONSerialization.ReadingOptions.allowFragments),
            let jsonItems = jsonDescrible as? Array<NSDictionary>
            else {
                assert(false, "JSONData have not contains the right data")
            return Array()
        }
        
        // We sure the jsonData have contains the right data
        var items = Array<ListItem>()
        for jsonItemDic in jsonItems {
            var item = ListItem()
            if let titleStr = jsonItemDic.object(forKey: "title") as? String{
                item.title = titleStr
            }
            
            if let imageName = jsonItemDic.object(forKey: "name") as? String {
                item.icon = UIImage(named: imageName)
            }
            
            if let urlStr = jsonItemDic.object(forKey: "url") as? String {
                item.url = URL.init(string: urlStr)
            }
            
            items.append(item)
        }
        
        return items
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
