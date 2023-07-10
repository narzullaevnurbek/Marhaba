//
//  ImagesGridPresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ImagesGridPresenterType {
    func presentData(response: ImagesGrid.Model.Response.ResponseType)
}

class ImagesGridPresenter: ImagesGridPresenterType {
    weak var viewController: ImagesGridViewControllerType?

    func presentData(response: ImagesGrid.Model.Response.ResponseType) {

        switch response {
        case .gotHotelImages(let images):
            viewController?.displayData(viewModel: .receiveHotelImages(images: images))
        case .gotRoomImages(let images):
            viewController?.displayData(viewModel: .receiveRoomImages(images: images))
        }
    }
  
}
