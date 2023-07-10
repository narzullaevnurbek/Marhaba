//
//  AuthRouter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 19/06/23.
//

import Foundation
import UIKit

protocol LoginRouterType {
    func navigateTo(toVC: UIViewController, animated: Bool)
    func networkConnection(isConnected: Bool)
    func userIsChecked(valid: Bool, loginType: UserLoginType)
    func popViewController(animated: Bool)
}

class LoginRouter: LoginRouterType {
    
    weak var viewController: LoginViewController?
    
    func navigateTo(toVC: UIViewController, animated: Bool) {
        viewController?.navigationController?.pushViewController(toVC, animated: animated)
    }
    

    func networkConnection(isConnected: Bool) {
        if !isConnected {
            viewController?.navigationController?.pushViewController(NetworkError(), animated: true)
        }
    }
    
    
    func userIsChecked(valid: Bool, loginType: UserLoginType) {
        if valid {
            if loginType == .email {
                viewController?.navigationController?.pushViewController(EmailConViewController(), animated: true)
            } else {
                viewController?.navigationController?.setViewControllers([AuthViewController()], animated: true)
            }
        } else {
            viewController?.displayData(viewModel: .invalidUser)
        }
    }
    
    
    func popViewController(animated: Bool) {
        viewController?.navigationController?.popViewController(animated: animated)
    }
    
}
