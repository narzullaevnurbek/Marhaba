//
//  HotelsPageRouter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HotelsPageRouterType {
    func navigate(toVC: UIViewController, animated: Bool)
    func networkConnection(isConnected: Bool)
    func popViewController(animated: Bool)
    func openMaps(URL: URL)
}

class HotelsPageRouter: NSObject, HotelsPageRouterType {

    weak var viewController: HotelsPageViewController?
  
  
    func navigate(toVC: UIViewController, animated: Bool) {
        viewController?.navigationController?.pushViewController(toVC, animated: animated)
    }
    
    
    func networkConnection(isConnected: Bool) {
        viewController?.navigationController?.pushViewController(NetworkError(), animated: true)
    }
    
    
    func popViewController(animated: Bool) {
        viewController?.navigationController?.popViewController(animated: animated)
    }
    
    
    func openMaps(URL: URL) {
        UIApplication.shared.open(URL)
    }
  
}
