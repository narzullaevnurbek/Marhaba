//
//  SkipModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import Foundation

enum Skip {
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkInternet
                case saveUser(userName: String)
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
