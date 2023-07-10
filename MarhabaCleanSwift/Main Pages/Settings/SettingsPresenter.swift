//
//  SettingsPresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SettingsPresenterType {
    func presentData(response: Settings.Model.Response.ResponseType)
}

class SettingsPresenter: SettingsPresenterType {
    weak var viewController: SettingsViewControllerType?

    func presentData(response: Settings.Model.Response.ResponseType) {

        switch response {
        case .internetResponse(let isConnected):
            viewController?.displayData(viewModel: .internetStatus(isConnected: isConnected))
        case .fetchedLocalUser(user: let user):
            viewController?.displayData(viewModel: .fetchedLocalUserData(user: user))
        }
    }
  
}
