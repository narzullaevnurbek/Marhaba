//
//  HotelsListModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum HotelsList {

    enum HotelSelection {
        case searchResult
        case notSearch
    }
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkInternet
            }
        }
        
        struct Response {
            enum ResponseType {
                case internetResponse(isConnected: Bool)
            }
        }
        
        struct ViewModel {
            enum ViewModelData {
                case internetStatus(isConnected: Bool)
            }
        }
        
    }

}
