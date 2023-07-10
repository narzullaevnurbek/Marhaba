//
//  ExploreModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 21/06/23.
//

import Foundation

enum HotelSelectionType {
    case bestAndAffordable
    case recommended
}

enum Explore {
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkInternet
                case clearMemoryCache
                case setSigned
                case fetchHotels(selection: HotelSelectionType)
                case fetchDestinationHotels(cityID: Int, cityName: String)
            }
        }
        
        struct Response {
            enum ResponseType {
                case internetResponse(isConnected: Bool)
                case fetchedHotels(hotels: [Hotel], selection: HotelSelectionType)
                case fetchedDestinationHotels(data: [Hotel], cityName: String)
            }
        }
        
        struct ViewModel {
            enum ViewModelData {
                case internetStatus(isConnected: Bool)
                case fetchedHotelsData(hotels: [Hotel], selection: HotelSelectionType)
                case fetchedDestinationHotels(data: [Hotel], cityName: String)
            }
        }
    }
    
}
