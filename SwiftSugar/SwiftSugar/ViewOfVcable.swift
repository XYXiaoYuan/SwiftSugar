//
//  ViewOfVcable.swift
//  SwiftSugar
//
//  Created by 袁小荣 on 2017/6/5.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

protocol ViewOfVcable {

}

extension ViewOfVcable where Self: UIView {

    func currentViewController() -> UIViewController? {

        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }

        return nil
    }
}

