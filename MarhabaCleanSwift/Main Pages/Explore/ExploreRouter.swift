//
//  ExploreRouter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 21/06/23.
//

import UIKit

protocol ExploreRouterType {
    func navigate(toVC: UIViewController, animated: Bool)
    func networkConnection(isConnected: Bool)
}

class ExploreRouter: ExploreRouterType {
    
    var viewController: ExploreViewController?
    
    func navigate(toVC: UIViewController, animated: Bool) {
        viewController?.navigationController?.pushViewController(toVC, animated: animated)
    }
    
    
    func networkConnection(isConnected: Bool) {
        viewController?.navigationController?.pushViewController(NetworkError(), animated: true)
    }
}
