//
//  Reusable.swift
//  SwiftSugar
//
//  Created by 袁小荣 on 2017/5/14.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reusableIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reusableIdentifier: String {
        return "\(self)"
    }
    
    // 默认是注册class,所以默认将nib值返回为空
    static var nib: UINib? {
        return nil
    }
}

// MARK:-UITableView注册cell扩展
extension UITableView {
    
    // 注册TableViewCell,可用Class,也可以Nib
    func registerCell<T: UITableViewCell>(_ cell: T.Type) where T: Reusable {
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.reusableIdentifier)
        } else {
            register(cell, forCellReuseIdentifier: T.reusableIdentifier)
        }
    }
    
    func dequeueReusableCell<T: Reusable>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as! T
    }
}

// MARK:-UICollectionView注册cell扩展
extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ cell: T.Type) where T:Reusable {
        if let nib = T.nib {
            register(nib, forCellWithReuseIdentifier: T.reusableIdentifier)
        } else {
            register(cell, forCellWithReuseIdentifier: T.reusableIdentifier)
        }
    }
    
    func dequeueReusableCell<T: Reusable>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as! T
    }
}



