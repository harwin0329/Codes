//
//  CocoaPodsViewController.swift
//  Codes
//
//  Created by chenzw on 2018/11/29.
//  Copyright © 2018 Gripay. All rights reserved.
//

import UIKit

class CocoaPodsViewController: BaseTextViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.text = "vi/vim 的使用  i 　切换到插入模式，vi/vim 使用实例 按下 ESC 按钮回到一般模式 在一般模式中按下 :wq 储存后离开 vi以输入字符。忽略老版本，直接加新添加的库 pod install --verbose --no-repo-update执行pod install的时候，遇到RuntimeError - [Xcodeproj] Unknown object version.- 原因: `xcode`版本和现在`CocoaPods `的版本问题`不匹配`。 - 解决方法:  更新`cocoaPods`的版本 ，在终端执行如下命令`gem install cocoapods --pre`，然后在相对应`podfile`文件所在路径下执行`pod install `即可。 在cocoapods 执行  sudo gem install cocoapods的时候出现  While executing gem ... (Gem::FilePermissionError) You don't have write permissions for the /usr/bin directory. 改为 sudo gem install -n /usr/local/bin cocoapods  即可"
    }
    

}
