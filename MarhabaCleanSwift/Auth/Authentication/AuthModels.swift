//
//  AuthModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 19/06/23.
//

import Foundation

enum Auth {
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkInternet
                case deleteUserData
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
