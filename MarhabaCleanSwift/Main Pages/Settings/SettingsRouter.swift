//
//  SettingsRouter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SettingsRouterType {
    func navigate(toVC: UIViewController, animated: Bool)
    func networkConnection(isConnected: Bool)
}

class SettingsRouter: NSObject, SettingsRouterType {

    weak var viewController: SettingsViewController?
  
    
    func navigate(toVC: UIViewController, animated: Bool) {
        viewController?.navigationController?.pushViewController(toVC, animated: animated)
    }
    
    
    func networkConnection(isConnected: Bool) {
        viewController?.navigationController?.pushViewController(NetworkError(), animated: true)
    }
}
