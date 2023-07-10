//
//  EmailPresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import Foundation

protocol EmailPresenterType {
    func presentData(response: Email.Model.Response.ResponseType)
}

class EmailPresenter: EmailPresenterType {
    
    var viewController: EmailConViewControllerType?
    
    func presentData(response: Email.Model.Response.ResponseType) {
        
        switch response {
        case .internetResponse(let isConnected):
            viewController?.displayData(viewModel: .internetStatus(isConnected: isConnected))
        case .OTPResent:
            viewController?.displayData(viewModel: .OTPChanged)
        case .fetchedLocalUser(let user):
            viewController?.displayData(viewModel: .fetchedLocalUserData(user: user))
        case .checkedOTP(valid: let valid):
            viewController?.displayData(viewModel: .OTPResult(valid: valid))
        }
        
    }
    
}
