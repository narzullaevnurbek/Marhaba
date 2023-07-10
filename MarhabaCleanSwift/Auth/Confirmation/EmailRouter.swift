//
//  EmailRouter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import UIKit

protocol EmailRouterType {
    func navigate(toVC: UIViewController, animated: Bool)
    func setPageTo(VC: UIViewController, animated: Bool)
    func networkConnection(isConnected: Bool)
    func popViewController(animated: Bool)
}

class EmailRouter: EmailRouterType {
    
    
    var viewController: EmailConViewController?
    
    func navigate(toVC: UIViewController, animated: Bool) {
        viewController?.navigationController?.pushViewController(toVC, animated: animated)
    }
    
    
    func setPageTo(VC: UIViewController, animated: Bool) {
        viewController?.navigationController?.setViewControllers([VC], animated: animated)
    }
    
    
    func networkConnection(isConnected: Bool) {
        if !isConnected {
            viewController?.navigationController?.pushViewController(NetworkError(), animated: true)
        }
    }
    
    
    func popViewController(animated: Bool) {
        viewController?.navigationController?.popViewController(animated: animated)
    }
    
}
