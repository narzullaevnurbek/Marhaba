//
//  AuthRouter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 19/06/23.
//

import Foundation
import UIKit

protocol AuthRouterType {
    func navigateTo(toVC: UIViewController, animated: Bool)
}

class AuthRouter: AuthRouterType {
    
    weak var viewController: AuthViewController?
    
    func navigateTo(toVC: UIViewController, animated: Bool) {
        viewController?.navigationController?.pushViewController(toVC, animated: animated)
    }
    
}
