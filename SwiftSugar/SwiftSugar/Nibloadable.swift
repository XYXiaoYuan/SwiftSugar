//
//  Nibloadable.swift
//  SwiftSugar
//
//  Created by 袁小荣 on 2017/5/14.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

protocol Nibloadable {
    
}

extension Nibloadable where Self: UIView {
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        
        let nib = nibname ?? "\(self)"
        return Bundle.init(for: self).loadNibNamed(nib, owner: nil, options: nil)?.first as! Self
    }
}
