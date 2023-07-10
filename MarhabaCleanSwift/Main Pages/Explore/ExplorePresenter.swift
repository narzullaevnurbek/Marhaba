//
//  ExplorePresenter.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 21/06/23.
//

import Foundation

protocol ExplorePresenterType {
    func presentData(response: Explore.Model.Response.ResponseType)
}

class ExplorePresenter: ExplorePresenterType {
    
    var viewController: ExploreViewControllerType?
    
    func presentData(response: Explore.Model.Response.ResponseType) {
        
        switch response {
        case .internetResponse(let isConnected):
            viewController?.displayData(viewModel: .internetStatus(isConnected: isConnected))
        case .fetchedHotels(let hotels, let selection):
            viewController?.displayData(viewModel: .fetchedHotelsData(hotels: hotels, selection: selection))
        case .fetchedDestinationHotels(let data, let cityName):
            viewController?.displayData(viewModel: .fetchedDestinationHotels(data: data, cityName: cityName))
        }
        
    }
}
