//
//  ViewControllerTwo.swift
//  Securing_iOS_Data
//
//  Created by linkapp on 08/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import UIKit

class ViewControllerTwo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ViewControllerTwo"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSecureObject(_ sender: Any) {
        self.save()
    }

    @IBAction func getSecureObject(_ sender: Any) {
        let document = self.loadFromSavedData()
        print(document?.description ?? "Document load failed")
    }
    

    /*
     对应的使用`NSSecureCoding`,在使用的是 `NSKeyedUnarchiver` 反序列化存储数据时，确定对应的属性`requiresSecureCoding`为`true`。
     */
    func loadFromSavedData() -> historyDocument?
    {
        var object : historyDocument? = nil
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let fileURL = url.appendingPathComponent("ArchiveExample.plist")
        if FileManager.default.fileExists(atPath: (fileURL?.path)!)
        {
            do
            {
                let data = try Data.init(contentsOf: fileURL!)
                let unarchiver = NSKeyedUnarchiver.init(forReadingWith: data)
                
                // 注意这个属性
                unarchiver.requiresSecureCoding = true
                object = unarchiver.decodeObject(of: historyDocument.self, forKey: NSKeyedArchiveRootObjectKey)
                unarchiver.finishDecoding()
            }
            catch
            {
                print(error)
            }
        }
        return object;
    }
    
    
    /*
     将`requiresSecureCoding`设置为`true` 也可以防止在使用`NSKeyedUnarchiver`进行存储的时候，自定义类为没有实现`NSSecureCoding`的发生。
     */
    func save()
    {
        let aDocument = historyDocument()
        aDocument.fileName = "Fuzz's Document"
        aDocument.serialNumber = 348573

        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("ArchiveExample.plist")?.path
        let data = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWith: data)
        
        // 注意这个属性
        archiver.requiresSecureCoding = true
        
        archiver.encode(aDocument, forKey: NSKeyedArchiveRootObjectKey)
        archiver.finishEncoding()
        let options : NSData.WritingOptions = [.atomic, .completeFileProtection]
        do
        {
            try data.write(toFile: filePath!, options:options)
        }
        catch
        {
            print(error)
        }
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
