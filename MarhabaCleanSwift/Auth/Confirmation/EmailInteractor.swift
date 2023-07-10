//
//  EmailInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import UIKit
import Network

protocol EmailInteractorType {
    func makeRequest(request: Email.Model.Request.RequestType)
}

class EmailInteractor: EmailInteractorType {
    
    var CoreData: CoreDB? = CoreDB()
    var Networking: NetworkManager? = NetworkManager()
    var MySQL: MySQLDB? = MySQLDB()
    
    var presenter: EmailPresenterType?
    
    func makeRequest(request: Email.Model.Request.RequestType) {
        
        switch request {
        case .checkInternet:
            checkInternet()
        case .resendOTP:
            resendOTP()
        case .fetchUserFromLocalDB:
            guard let user = CoreData?.fetchUser() else { return }
            presenter?.presentData(response: .fetchedLocalUser(user: user))
        case .checkOTP(let otpCode):
            checkOTP(otpCode: otpCode)
        case .appMovedToBackground:
            CoreData?.deleteAll()
        }
        
    }
    
    
    func checkInternet() {
        let queue = DispatchQueue(label: "Network")
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in

            if path.status != .satisfied {
                DispatchQueue.main.async {
                    self.presenter?.presentData(response: .internetResponse(isConnected: false))
                }
            }

        }
        monitor.start(queue: queue)
    }
    
    
    private func resendOTP() {
        guard let user = CoreData?.fetchUser() else {
            print("Error while resending OTP")
            return
        }
        Networking?.sendOTP(email: user.email!)
        presenter?.presentData(response: .OTPResent)
    }
    
    
    private func checkOTP(otpCode: String) {
        guard let user = CoreData?.fetchUser() else { return }
        guard let userName = user.name else { return }
        guard let userEmail = user.email else { return }
        let userOTP = user.otpCode
        
        if otpCode.count == 4 && otpCode == String(userOTP) {
            presenter?.presentData(response: .checkedOTP(valid: true))
            MySQL?.saveUser(name: userName, email: userEmail)
            
        } else if otpCode.count == 4 && otpCode != String(userOTP) {
            presenter?.presentData(response: .checkedOTP(valid: false))
            
        } else {
            presenter?.presentData(response: .checkedOTP(valid: false))
        }
    }
}
