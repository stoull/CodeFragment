//
//  JSON.swift
//  Thinking in Swift
//
//  Created by Stoull Hut on 31/07/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

import Foundation
import UIKit

/*
 READ ME
 
 本项目主要体验下Swift的严谨和安全性。主要对可选类型，对象有无值，对象是否是对应的类型，异常，类型转换，是否是初始等等作些思考。
 
 主要参考这一篇的学习记录
 http://alisoftware.github.io/swift/2015/09/06/thinking-in-swift-1/
 http://alisoftware.github.io/swift/2015/09/20/thinking-in-swift-2/
 https://alisoftware.github.io/swift/2015/10/03/thinking-in-swift-3/
 
 Swift 编程思想，第一部分：拯救小马：
 http://swift.gg/2015/09/29/thinking-in-swift-1/
 
 Swift 编程思想，第二部分：数组的 Map 方法：
 http://swift.gg/2015/10/09/thinking-in-swift-2/
 
 Swift 编程思想，第三部分：结构体和类：
 http://swift.gg/2015/10/20/thinking-in-swift-3/

 */


class ListItem {
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
     2. 不要随便强制解包 ! ，除非你知道那里面一定有值，否则一定要考虑当为nil的情况
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
    
    /*
    
    static func listItemsFromJSONData(jsonData: Data?) -> Array<ListItem>? {
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
    
     */
    
    // 第四次解析JSON数据
    
    /*
     第三次重写的代码还是不够Swift-er编程语言风格，可以再做些精简：
     1. 使用map()方法。
     map() 是 Array 提供的方法，通过接收一个函数作为传入参数，对数组中每个元素进行函数变换得到新的结果值。这样只需要提供X->Y的映射关系，就能将数组[X]变换到新数组[Y]，而无需创建一个临时可变数组(注:即上面代码中的items变量)。
     这样就可以移除 for 循环
     
     */
    
    /*
    static func listItemsFromJSONData(jsonData: Data?) -> Array<ListItem>? {
        guard let noNilData = jsonData,
            let jsonDescrible = try? JSONSerialization.jsonObject(with: noNilData, options: JSONSerialization.ReadingOptions.allowFragments),
            let jsonItems = jsonDescrible as? Array<NSDictionary>
            else {
                assert(false, "JSONData have not contains the right data")
                return nil
        }
        
        return jsonItems.map({ (itemDic: NSDictionary) -> ListItem in
            guard let titleStr = itemDic.object(forKey: "title") as? String,
                let imageName = itemDic.object(forKey: "name") as? String,
                let urlStr = itemDic.object(forKey: "url") as? String
                else {
                    return ListItem()
            }
            var item = ListItem()
            item.title = titleStr
            item.icon = UIImage.init(named: imageName)
            item.url = URL.init(string: urlStr)
            return item;
        })
    }
    
    */
    
    // 第五次解析JSON数据
    
    /*
     第四次重写的代码中，如果数据值无效的时候，我们返回的是一个nil。如果是一个nil为什么返回呢，还不如把它丢弃掉，这样就可以保持数据的有效性。
     1. flatMap()
     从语法上，你可以这么理解，flatMap 就是先使用 map处理数组，接着将结果数组“压平”（顾名思义)，也就是从输出数组里剔除值为nil的元素。
     */
    
    static func listItemsFromJSONData(jsonData: Data?) -> Array<ListItem>? {
        guard let noNilJSONData = jsonData,
        let jsonDescrible = try? JSONSerialization.jsonObject(with: noNilJSONData, options: JSONSerialization.ReadingOptions.allowFragments),
        let jsonItems = jsonDescrible as? Array<NSDictionary>
        else {
            assert(false, "")
            return nil
        }
        
        return jsonItems.flatMap({ (itemDic: NSDictionary) -> ListItem? in
            guard let titleStr = itemDic.object(forKey: "title") as? String,
            let urlStr = itemDic.object(forKey: "url") as? String,
            let url = URL.init(string: urlStr)
                else{
                    return nil
            }
            let item = ListItem()
            if let imageStr = itemDic.object(forKey: "name") as? String {
                item.icon = UIImage.init(named: imageStr)
            }
            item.title = titleStr
            item.url = url
            return item
        })
        
        
    }
}


// 第六次解析JSON数据
/*
 1. class转换成struct
    首先考虑使用类(class)是Swift初学者经常犯的一个错误。
    Swift的结构体(structs)和类(Class)具有相同的功能 - 除了继承 - 结构体是值类型(value-types) (所以每一次变量赋值都是通过值拷贝的形式，与Int类型很相像)，而类属于引用类型(reference-types)，以引用方式传递而非值拷贝，这和Objective-C(以及OC中无处不在的难看的*，也代表着引用)中一样。
 
 2. 联合操作符(Coalescing operator) ??
 */

struct DataItem {
    var title : String = ""
    var icon: UIImage?
    var url: URL
    
    static func listItemsFromJSONData(jsonData: Data?) -> Array<DataItem>? {
        guard let noNilData = jsonData, let jsonDescrible = try? JSONSerialization.jsonObject(with: noNilData, options: JSONSerialization.ReadingOptions.allowFragments), let jsonItems = jsonDescrible as? Array<NSDictionary>
            else {
            return Array()
        }
        
        return jsonItems.flatMap({ (itemDic: NSDictionary) -> DataItem? in
            guard let titleStr = itemDic.object(forKey: "title") as? String,
            let urlStr = itemDic.object(forKey: "url") as? String,
                let url = URL.init(string: urlStr)
                else {
                return nil
            }
            
            let iconName = itemDic.object(forKey: "name") as? String
            let icon = UIImage.init(named: iconName ?? "")
            return DataItem(title: titleStr, icon: icon, url: url)
        })
    }
    
}
