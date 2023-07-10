//
//  LoginModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 19/06/23.
//

import Foundation

enum UserLoginType {
    case email
    case google
    case apple
}

enum Login {
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkInternet
                case saveDemoAccount(email: String, name: String)
                case checkUser(email: String)
                case googleLogin(email: String)
                case appleLogin(email: String)
            }
        }
        
        struct Response {
            enum ResponseType {
                case internetResponse(isConnected: Bool)
                case userIsChecked(valid: Bool, loginType: UserLoginType)
            }
        }
        
        struct viewModel {
            enum viewModelData {
                case internetStatus(isConnected: Bool)
                case userIsChecked(valid: Bool, loginType: UserLoginType)
                case invalidUser
            }
        }
    }
    
}
