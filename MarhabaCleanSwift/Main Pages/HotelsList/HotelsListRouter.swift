//
//  HotelsListRouter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HotelsListRouterType {
    func navigate(toVC: UIViewController, animated: Bool)
    func networkConnection(isConnected: Bool)
    func popViewController(animated: Bool)
}

class HotelsListRouter: NSObject, HotelsListRouterType {

    weak var viewController: HotelsListViewController?
  
  
    func navigate(toVC: UIViewController, animated: Bool) {
        viewController?.navigationController?.pushViewController(toVC, animated: animated)
    }
    
    
    func networkConnection(isConnected: Bool) {
        viewController?.navigationController?.pushViewController(NetworkError(), animated: true)
    }
    
    
    func popViewController(animated: Bool) {
        viewController?.navigationController?.popViewController(animated: animated)
    }
  
}
