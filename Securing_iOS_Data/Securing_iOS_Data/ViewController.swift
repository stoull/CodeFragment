//
//  ViewController.swift
//  Securing_iOS_Data
//
//  Created by linkapp on 07/08/2017.
//  Copyright © 2017 Hut. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    var isPRDAvailable: Bool = UIApplication.shared.isProtectedDataAvailable
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ViewController"
        
        if let testPathStr = self.testFilePath() as String? {
            let testString = "Test Data Protection"
            let strData = testString.data(using: .utf8)
            if let noNilData = strData {
                do {
                    let testFileUrl = URL.init(fileURLWithPath: testPathStr, isDirectory: false)
                    // 将数据写入文件时，设置对应的保护级别
                    try noNilData.write(to: testFileUrl, options: Data.WritingOptions.completeFileProtectionUntilFirstUserAuthentication)
                    print("writeDataToFile: succeed")
                } catch {
                    print("writeDataToFile: TestDataWriteFailed \(error)")
                }
            }else {
                print("writeDataToFile: TestData is nil")
            }
        }else {
            print("writeDataToFile: Can not get the dcoument Directory")
        }
        
        
        
        
        // 观察数据是否被保护，是否去访问数据
        NotificationCenter.default.addObserver(forName: .UIApplicationProtectedDataDidBecomeAvailable, object: nil, queue: OperationQueue.main, using: { (notification) in
            self.isPRDAvailable = true
        })
        
        NotificationCenter.default.addObserver(forName: .UIApplicationProtectedDataWillBecomeUnavailable, object: nil, queue: OperationQueue.main, using: { (notification) in
            self.isPRDAvailable = false
        })
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    // 安全删除文件 数据销毁
    /*
     要真正的删除一个文件，一个方法是在删除这个文件之前，随机的写入些数据覆盖原先的文件数据，然后移除出应的文件引用。
     */
    @IBAction func secureWipeFile(_ sender: Any) {
        if let testFilePath = self.testFilePath() as String? {
            
            print("\(testFilePath)")
            
            let cArray = testFilePath.cString(using: .utf8)
            let wipeStatus = SecureWipeFile(cArray)
            
            if wipeStatus == 0 {
                print("secureWipeFile: 数据覆盖成功")
                
                // 删除对应的文件
                do {
                    try FileManager.default.removeItem(atPath: testFilePath)
                } catch {
                    print("FileManager removeItem \(error)")
                }
            }
        }
        
        // Interacting with C APIs
        // https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithCAPIs.html
    }
    
    
    // 改别已存在文件的保护级别：
    @IBAction func changeFileProtectlevel(_ sender: Any) {
        if let path = self.testFilePath() as String? {
            do
            {
                try FileManager.default.setAttributes([FileAttributeKey.protectionKey : FileProtectionType.complete], ofItemAtPath: path)
            }
            catch
            {
                print(error)
            }
        }
    }
    
    // 创建被保护的文件或文件夹
    @IBAction func createProtectFile(_ sender: Any) {
        let testFilePath = self.testFilePath()
        if let testPath = testFilePath as String? {
            
            // 创建被保护的文件
//            let ok = FileManager.default.createFile(atPath: testPath, contents: nil, attributes: [FileAttributeKey.protectionKey.rawValue: FileProtectionType.complete])
//            if ok {
//                print("createFile: succeed")
//            }else {
//                print("createFile: failed")
//            }
//
            do
            {
                 // 创建被保护的文件夹
                try FileManager.default.createDirectory(atPath: testPath, withIntermediateDirectories: true, attributes: [FileAttributeKey.protectionKey.rawValue: FileProtectionType.complete])
            }
            catch
            {
                print(error)
            }
        }
    }

    // 读取被保护的文件
    @IBAction func accessProtectedFile(_ sender: UIButton) {
        // 判断数据保护是否可用
        if UIApplication.shared.isProtectedDataAvailable {
            if let testFilePath = self.testFilePath() as String? {
                let testFileURL = URL.init(fileURLWithPath: testFilePath, isDirectory: false)
                do {
                    let readData = try Data.init(contentsOf: testFileURL)
                    let testStr = String.init(data: readData, encoding: String.Encoding.utf8)
                    print("Test data: \(String(describing: testStr))")
                } catch {
                    print("accessProtectedFile: NO file data \(error)")
                }
            }else {
                print("accessProtectedFile: File is not exist")
            }
        }else {
            print("accessProtectedFile: File is protected")
        }
    }
    
    
    // 访问，获取或修改系统的资源
    @IBAction func requestPhotosAuthorization(_ sender: UIButton) {
        
        /*
         比如你要访问系统的相册，你就需要在info.plist文件需要对应的声明：
         <key> NSPhotoLibraryUsageDescription </key>
         <string>APPNAME wants access your photos</string>
        */
        PHPhotoLibrary.requestAuthorization { (status) in
            print("Authorization status: \(status)")
        }
    }
    
    
    
    func testFilePath() -> NSString? {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first as NSString?
        guard var docPathStr = docPath else {
            return nil
        }
        docPathStr = docPathStr.appendingPathComponent("TestFile.txt") as NSString
        return docPathStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
