//
//  SettingsModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Settings {
   
    enum Model {
        struct Request {
            enum RequestType {
                case checkInternet
                case fetchUserFromLocalDB
                case update(value: Int64, selection: UpdateSelection)
                case eraseCoreData
                case logOut
                case deleteAccount
            }
        }
            
        struct Response {
            enum ResponseType {
                case fetchedLocalUser(user: User)
                case internetResponse(isConnected: Bool)
            }
        }
            
        struct ViewModel {
            enum ViewModelData {
                case fetchedLocalUserData(user: User)
                case internetStatus(isConnected: Bool)
            }
        }
    }
  
}
