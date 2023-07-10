//
//  SearchEngineRouter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchEngineCellRouterType {
    func navigate(fromVC: UIViewController, toVC: UIViewController, animated: Bool)
}

class SearchEngineCellRouter: NSObject, SearchEngineCellRouterType {

    weak var viewController: SearchEngineCell?
    
    
    func navigate(fromVC: UIViewController, toVC: UIViewController, animated: Bool) {
        fromVC.navigationController?.pushViewController(toVC, animated: animated)
    }
  
}
