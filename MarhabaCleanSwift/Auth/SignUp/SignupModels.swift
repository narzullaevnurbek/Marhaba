//
//  SignupModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import Foundation

enum Signup {
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkInternet
                case saveDemoAccount(email: String, name: String)
                case checkUser(email: String, name: String)
                case googleSignup(email: String, name: String)
                case appleSignup(email: String, name: String)
            }
        }
        
        struct Response {
            enum ResponseType {
                case internetResponse(isConnected: Bool)
                case userIsChecked(valid: Bool, signupType: UserLoginType)
            }
        }
        
        struct ViewModel {
            enum ViewModelData {
                case internetStatus(isConnected: Bool)
                case userIsChecked(valid: Bool, signupType: UserLoginType)
                case invalidUser
            }
        }
    }
    
}
