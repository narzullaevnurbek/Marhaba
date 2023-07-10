//
//  LoginPresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 19/06/23.
//

import Foundation

protocol LoginPresenterType {
    func presentData(response: Login.Model.Response.ResponseType)
}

class LoginPreseneter: LoginPresenterType {
    
    var viewController: LoginViewControllerType?
    
    func presentData(response: Login.Model.Response.ResponseType) {
        
        switch response {
        case .internetResponse(let isConnected):
            viewController?.displayData(viewModel: .internetStatus(isConnected: isConnected))
        case .userIsChecked(let valid, let loginType):
            viewController?.displayData(viewModel: .userIsChecked(valid: valid, loginType: loginType))
        }
        
    }
    
}
