//
//  SearchEngineModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SearchEngine {
   
    enum Model {
        struct Request {
            enum RequestType {
                case fetchUserFromLocalDB
                case searchHotels(city: String, nightsCount: Int, adults: Int, children: Int, rooms: Int)
            }
        }
            
        struct Response {
            enum ResponseType {
                case fetchedLocalUser(user: User)
                case gotSearchedHotels(data: [Hotel])
            }
        }
            
        struct ViewModel {
            enum ViewModelData {
                case fetchedLocalUserData(user: User)
                case receiveSearchedHotels(data: [Hotel])
            }
        }
    }
  
}
