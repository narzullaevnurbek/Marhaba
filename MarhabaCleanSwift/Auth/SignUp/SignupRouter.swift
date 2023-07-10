//
//  SignupRouter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import UIKit

protocol SignupRouterType {
    func navigateTo(toVC: UIViewController, animated: Bool)
    func networkConnection(isConnected: Bool)
    func userIsChecked(valid: Bool, loginType: UserLoginType)
    func popViewController(animated: Bool)
}

class SignupRouter: SignupRouterType {
    
    var viewController: SignupViewController?
    
    
    func navigateTo(toVC: UIViewController, animated: Bool) {
        viewController?.navigationController?.pushViewController(toVC, animated: animated)
    }
    
    
    func networkConnection(isConnected: Bool) {
        viewController?.navigationController?.pushViewController(NetworkError(), animated: true)
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
