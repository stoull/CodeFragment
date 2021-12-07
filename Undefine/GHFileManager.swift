//
//  GHFileManager.swift
//  MyGro
//
//  Created by Hut on 2021/11/25.
//  Copyright © 2021 Growatt New Energy Technology CO.,LTD. All rights reserved.
//

import UIKit

enum GHFileManagerDirectoryType {
    /// 对应 cachesDirectory  目录
    case caches
    /// 对应 documentDirectory 目录
    case document
    /// 对应 NSTemporaryDirectory()
    case temporaray
    
    var directoryUrl: URL {
        var dirUrl: URL
        switch self {
        case .caches:
            dirUrl = MGFileManager.cachesDir
        case .document:
            dirUrl = MGFileManager.documentDir
        case .temporaray:
            dirUrl = MGFileManager.temporaray
        }
        return dirUrl
    }
}

struct MGFileManager {
    /// 对应 cachesDirectory  目录
    static let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    /// 对应 documentDirectory 目录
    static let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    static let temporaray = URL(fileURLWithPath: NSTemporaryDirectory())
    
    private static let kCachedSerializedDirectory = "cached_serialized_info/"
    private static let kCachedImageDirectory = "cached_create_image/"
    private static let kObjectPersistentDicrectory = "Object_Persistent/"
    
    /// 测试用！ 从Bundle加载对象存储的对象信息（可能是json或者Dictionary）
    static func loadSerializedFileFromResource(fileName: String, type: String?=nil) -> Any? {
        if let sourcePath = Bundle.main.path(forResource: fileName, ofType: type),
           let data = FileManager.default.contents(atPath: sourcePath),
           let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
            // json 格式
            return jsonObject
        } else {
            // dictionary 格式
            var format = PropertyListSerialization.PropertyListFormat.xml
            if let sourcePath = Bundle.main.path(forResource: fileName, ofType: type),
               let data = FileManager.default.contents(atPath: sourcePath),
               let dic = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &format) as? [String : AnyObject]{
                return dic
            }
        }
        return nil
    }
    
    /// 从图片缓存目录读取图片
    static func readImage(fromDirectory directroy:GHFileManagerDirectoryType, fileName: String) -> UIImage? {
        let deviceScale = UIScreen.main.scale
        guard let data = self.readData(fromRooDir: directroy.directoryUrl, directory: Self.kCachedImageDirectory, fileName: fileName),
              let image = UIImage(data: data, scale: deviceScale) else {
            return nil
        }
        return image
    }
    
    /// 将图片文件写入到图片缓存目录
    static func saveImage(toDirectory directroy:GHFileManagerDirectoryType, image: UIImage, fileName: String) {
         if let imageData = image.pngData() {
             let _ = self.saveData(toRootDir: directroy.directoryUrl, directory: Self.kCachedImageDirectory, data: imageData, fileName: fileName)
         }
     }
    
    /// 将可序列化的对象保存在缓存目录
    static func saveSerializedInfo(toDirectory directroy:GHFileManagerDirectoryType, fileName: String, obj:Any) -> Bool {
        if let data = try? JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed) {
            return self.saveData(toRootDir: directroy.directoryUrl, directory: Self.kCachedSerializedDirectory, data: data, fileName: fileName)
        } else {
            return false
        }
    }
    
    /// 从缓存目录读取可序列化的对象
    static func readSerializedInfo(fromDirectory directroy:GHFileManagerDirectoryType, fileName: String) -> Any? {
        guard let data = self.readData(fromRooDir: directroy.directoryUrl, directory: Self.kCachedSerializedDirectory, fileName: fileName),
              let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)else {
            return nil
        }
        return jsonObj
    }
    
    
    /// 将Encodable对象保存在用户目录
    static func savePersistentInstance<T: Encodable>(instance: T, toDirectory directroy:GHFileManagerDirectoryType, fileName: String){
        guard let codedObj = try? JSONEncoder().encode(instance) else {
            debugPrint("PersistentInstance Failed!")
            return
        }
        
        if self.saveData(toRootDir: directroy.directoryUrl, directory: Self.kObjectPersistentDicrectory, data: codedObj, fileName: fileName) == true {
            debugPrint("PersistentInstance Successful!")
        } else {
            debugPrint("PersistentInstance Failed!")
        }
    }
    
    /// 从用户目录读取Encodable对象
    static func readPersistentedInstance<T: Decodable>(instanceType: T.Type, fromDirectory directroy:GHFileManagerDirectoryType, fileName: String) -> T? {
        guard let data = self.readData(fromRooDir: directroy.directoryUrl, directory: Self.kObjectPersistentDicrectory, fileName: fileName) else {
            return nil
        }
        do {
            let decodedObj = try JSONDecoder().decode(instanceType, from: data)
            return decodedObj
        } catch let error {
            debugPrint("convert PersistentedInstance  error: \(error)")
            return nil
        }
    }
    
    private static func readData(fromRooDir rootUrl: URL, directory: String, fileName: String) -> Data? {
        var fileUrl = rootUrl
        fileUrl = fileUrl.appendingPathComponent(directory, isDirectory: true)
        fileUrl.appendPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            if let data = FileManager.default.contents(atPath: fileUrl.path){
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
  
    private static func saveData(toRootDir rootUrl: URL, directory: String, data: Data, fileName: String) -> Bool {
        var fileUrl = rootUrl
        fileUrl = fileUrl.appendingPathComponent(directory, isDirectory: true)
        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: fileUrl.path, isDirectory: &isDir) {
            if isDir.boolValue == false {
                try? FileManager.default.createDirectory(at: fileUrl, withIntermediateDirectories: true, attributes: nil)
            }
        } else {
            try? FileManager.default.createDirectory(at: fileUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
        fileUrl.appendPathComponent(fileName)
        do {
            try data.write(to: fileUrl)
            return true
        } catch {
            print("Write Data falied \(error.localizedDescription)")
            return false
        }
    }
}
