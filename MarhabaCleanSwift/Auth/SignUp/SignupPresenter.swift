//
//  SignupPresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import Foundation

protocol SignupPresenterType {
    func presentData(response: Signup.Model.Response.ResponseType)
}

class SignupPresenter: SignupPresenterType {
    
    var viewController: SignupViewControllerType?
    
        
    func presentData(response: Signup.Model.Response.ResponseType) {
        
        switch response {
        case .internetResponse(let isConnected):
            viewController?.displayData(viewModel: .internetStatus(isConnected: isConnected))
        case .userIsChecked(valid: let valid, signupType: let loginType):
            viewController?.displayData(viewModel: .userIsChecked(valid: valid, signupType: loginType))
        }
        
    }
    
}

