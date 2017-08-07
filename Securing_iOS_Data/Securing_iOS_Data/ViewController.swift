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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        if let docPathStr = docPath {
            let strData = NSData.init(base64Encoded: "Test Data Protection", options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            if let noNilData = strData {
                do {
                    // 将数据写文件时设置数据保护级别
                    try noNilData.write(toFile: docPathStr, options: NSData.WritingOptions.completeFileProtectionUntilFirstUserAuthentication)
                } catch {
                    print("TestDataWriteFailed")
                }
            }else {
                print("TestData is nil")
            }
        }else {
            print("Can not get the dcoument Directory")
        }
        
        
        
        
        // 观察数据是否被保护，是否去访问数据
        NotificationCenter.default.addObserver(forName: .UIApplicationProtectedDataDidBecomeAvailable, object: nil, queue: OperationQueue.main, using: { (notification) in
            //...
        })
        
        NotificationCenter.default.addObserver(forName: .UIApplicationProtectedDataWillBecomeUnavailable, object: nil, queue: OperationQueue.main, using: { (notification) in
            //...
        })
        
        let isProtectedDataAvailable = UIApplication.shared.isProtectedDataAvailable
        if isProtectedDataAvailable {
            let readData = NSData.init(contentsOfFile: <#T##String#>)
            let testStr = NSData.base64EncodedData(<#T##NSData#>)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        if let docPathStr = docPath {
            print("documentDirectory : \(docPathStr)")
        }
    }
    
    
    @IBAction func requestPhotosAuthorization(_ sender: UIButton) {
        
        /* 当我们要访问，获取或修改系统的资源
         比如你要访问系统的相册，你就需要在info.plist文件需要对应的声明：
         <key> NSPhotoLibraryUsageDescription </key>
         <string>APPNAME wants access your photos</string>
        */
        PHPhotoLibrary.requestAuthorization { (status) in
            print("Authorization status: \(status)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

