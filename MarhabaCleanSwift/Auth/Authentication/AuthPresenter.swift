//
//  AuthPresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 19/06/23.
//

import Foundation

protocol AuthPresenterType: AnyObject {
    func presentData(response: Auth.Model.Response.ResponseType)
}

class AuthPresenter: AuthPresenterType {
    
    weak var viewController: AuthViewControllerType?
    
    func presentData(response: Auth.Model.Response.ResponseType) {
        
        switch response {
        case .internetResponse(let isConnected):
            viewController?.displayData(viewModel: .internetStatus(isConnected: isConnected))
        }
        
    }
    
}
