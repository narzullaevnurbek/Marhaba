//
//  HotelsPagePresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HotelsPagePresenterType {
    func presentData(response: HotelsPage.Model.Response.ResponseType)
}

class HotelsPagePresenter: HotelsPagePresenterType {
    weak var viewController: HotelsPageViewControllerType?

    func presentData(response: HotelsPage.Model.Response.ResponseType) {
        
        switch response {
        case .internetResponse(let isConnected):
            viewController?.displayData(viewModel: .internetStatus(isConnected: isConnected))
        case .gotHotel(let hotel):
            viewController?.displayData(viewModel: .receiveHotel(hotel: hotel))
        case .gotAmens(let amens):
            viewController?.displayData(viewModel: .receiveAmens(amens: amens))
        case .gotRooms(let rooms):
            viewController?.displayData(viewModel: .receiveRooms(rooms: rooms))
        case .gotRoomImages(let roomImages):
            viewController?.displayData(viewModel: .receiveRoomImages(roomImages: roomImages))
        }
    }
  
}
