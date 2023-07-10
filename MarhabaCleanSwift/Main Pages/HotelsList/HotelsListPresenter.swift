//
//  HotelsListPresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HotelsListPresenterType {
  func presentData(response: HotelsList.Model.Response.ResponseType)
}

class HotelsListPresenter: HotelsListPresenterType {
    weak var viewController: HotelsListViewControllerType?

    func presentData(response: HotelsList.Model.Response.ResponseType) {
        
        switch response {
        case .internetResponse(let isConnected):
            viewController?.displayData(viewModel: .internetStatus(isConnected: isConnected))
        }
    }
  
}
