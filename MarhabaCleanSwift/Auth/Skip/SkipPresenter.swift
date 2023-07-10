//
//  SkipPresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import Foundation

protocol SkipPresenterType {
    func presentData(response: Skip.Model.Response.ResponseType)
}

class SkipPresenter: SkipPresenterType {
    
    var viewController: SkipViewControllerType?
    
    func presentData(response: Skip.Model.Response.ResponseType) {
        
        switch response {
        case .internetResponse(let isConnected):
            viewController?.displayData(viewModel: .internetStatus(isConnected: isConnected))
        }
        
    }
    
}
