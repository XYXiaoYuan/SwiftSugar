//
//  CacheSizable.swift
//  SwiftSugar
//
//  Created by 袁小荣 on 2017/5/19.
//  Copyright © 2017年 袁小荣. All rights reserved.
//  获取沙盒缓存大小

import UIKit

struct cacheSize<String> {
    let sizeString: String?

    init(sizeString: String) {
        self.sizeString = sizeString
    }
}

protocol CacheSizable {

}

extension CacheSizable {

    func removeCacheFilesByDirectoryPath(directoryPath: String) {
        // 获取文件管理者
        let manger = FileManager.default
        var isDirectory: ObjCBool = false;
        let isExist = manger.fileExists(atPath: directoryPath, isDirectory: &isDirectory)

        if (!isExist || !(isDirectory.boolValue)) {
            // 抛出异常
            fatalError("笨蛋 需要传入的是文件夹路径,并且路径要存在")
        }

        do {
            let subPaths = try manger.contentsOfDirectory(atPath: directoryPath)
            for subPath in subPaths {
                let filePath = directoryPath.appending("/\(subPath)")
                do {
                    try manger.removeItem(atPath: filePath)

                } catch  {
                    print("error:\(error)")
                }
            }
        } catch {
            print("error:\(error)")
        }
    }

    func getCacheFileSize(directoryPath: String, completion: @escaping (cacheSize<String>) -> Void) {
        // 获取文件管理者
        let manger = FileManager.default
        var isDirectory: ObjCBool = false;
        let isExist = manger.fileExists(atPath: directoryPath, isDirectory: &isDirectory)

        if (!isExist || !(isDirectory.boolValue)) {
            // 抛出异常
            fatalError("笨蛋 需要传入的是文件夹路径,并且路径要存在")
        }

        DispatchQueue.global().async(execute: { () -> Void in

            // 获取文件全路径
            let subPaths = manger.subpaths(atPath: directoryPath)

            // 定义文件大小
            var totalSize: Float = 0.0
            for subPath in subPaths! {
                let filePath = directoryPath.appending("/\(subPath)")

                // 判断隐藏文件
                if filePath .contains(".DS_Store") {
                    continue
                }

                // 判断是否为文件夹
                var isDirectory: ObjCBool = false
                // 判断文件是否存在,并且判断是否是文件夹
                let isExist = manger.fileExists(atPath: filePath, isDirectory: &isDirectory)
                if (!isExist || isDirectory.boolValue) {
                    continue
                }

                // 获取文件属性
                do {
                    let attr = try manger.attributesOfItem(atPath: filePath)
                    // 获取文件大小
                    let fileSize = attr[FileAttributeKey.size] as! Float
                    totalSize += fileSize
                } catch {
                    print("error:\(error)")
                }
            }

            // 通过计算,返回出去的就是带单位的缓存大小,如398KB,3MB
            let units = ["B", "KB", "MB", "GB"]
            let count: Float = 1000.0
            var index: Int = 0
            while totalSize > count {
                totalSize = totalSize / count
                index += 1
            }

            let formatTotalSizeStr = "\(String(format: "%.2f", totalSize))\(units[index])"
            DispatchQueue.main.async(execute: { () -> Void in
                completion(cacheSize.init(sizeString: formatTotalSizeStr))
            })
            
        })
    }
}
