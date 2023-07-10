//
//  EmailModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import Foundation

enum Email {
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkInternet
                case resendOTP
                case fetchUserFromLocalDB
                case checkOTP(otpCode: String)
                case appMovedToBackground
            }
        }
        
        struct Response {
            enum ResponseType {
                case internetResponse(isConnected: Bool)
                case OTPResent
                case fetchedLocalUser(user: User)
                case checkedOTP(valid: Bool)
            }
        }
        
        struct ViewModel {
            enum ViewModelData {
                case internetStatus(isConnected: Bool)
                case OTPChanged
                case fetchedLocalUserData(user: User)
                case OTPResult(valid: Bool)
            }
        }
    }
    
}
