//
//  BaseNavigationController.swift
//  zeniko
//
//  Created by Choi on 2022/8/25.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    /// 让最顶部的控制器决定状态栏的样式
    override var childForStatusBarStyle: UIViewController? {
        topViewController?.childForStatusBarStyle ?? topViewController
    }
}
