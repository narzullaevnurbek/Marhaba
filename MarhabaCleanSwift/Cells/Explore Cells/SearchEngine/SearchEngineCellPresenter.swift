//
//  SearchEnginePresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchEngineCellPresenterType {
    func presentData(response: SearchEngine.Model.Response.ResponseType)
}

class SearchEngineCellPresenter: SearchEngineCellPresenterType {
    weak var viewController: SearchEngineCellType?

    func presentData(response: SearchEngine.Model.Response.ResponseType) {

        switch response {
        case .fetchedLocalUser(let user):
            viewController?.displayData(viewModel: .fetchedLocalUserData(user: user))
        case .gotSearchedHotels(let data):
            viewController?.displayData(viewModel: .receiveSearchedHotels(data: data))
        }
    }
  
}
