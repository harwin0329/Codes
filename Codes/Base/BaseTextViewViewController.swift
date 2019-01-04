//
//  BaseTextViewController.swift
//  Codes
//
//  Created by chenzw on 2018/11/29.
//  Copyright © 2018 Gripay. All rights reserved.
//

import UIKit

class BaseTextViewController: UIViewController {
    
    lazy var textView = {() -> (UITextView) in
        //闭包中 self.容易引起循环引用
        let v = UITextView.init(frame: view.frame)
        v.font = UIFont.systemFont(ofSize: 14.0)
        view.addSubview(v)
        return v
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

}
