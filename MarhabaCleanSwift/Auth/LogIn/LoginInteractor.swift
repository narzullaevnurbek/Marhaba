//
//  LogInInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 19/06/23.
//

import Foundation
import Network
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

protocol LoginInteractorType {
    func makeRequest(request: Login.Model.Request.RequestType)
}

class LoginInteractor: LoginInteractorType {
    
    var presenter: LoginPresenterType?
    
    var CoreData: CoreDB? = CoreDB()
    var MySQL: MySQLDB? = MySQLDB()
    var Networking: NetworkManager? = NetworkManager()
    
    
    func makeRequest(request: Login.Model.Request.RequestType) {
        
        switch request {
        case .checkInternet:
            checkInternet()
        case .saveDemoAccount(let email, let name):
            CoreData?.saveUser(email: email, name: name)
        case .checkUser(let email):
            checkUserInServer(email: email)
        case .googleLogin(let email):
            googleLogin(email: email)
        case .appleLogin(let email):
            appleLogin(email: email)
        }
        
    }
    
    
    private func checkUserInServer(email: String) {
        
        
        MySQL?.fetchUser(email: email, completed: { [weak self] userExists, userName in
            guard let self = self else { return }

            if userExists {
                self.Networking?.sendOTP(email: email)
                self.CoreData?.saveUser(email: email, name: userName)
                presenter?.presentData(response: .userIsChecked(valid: true, loginType: .email))
            } else {
                presenter?.presentData(response: .userIsChecked(valid: false, loginType: .email))
            }
        })
    }
    
    
    private func appleLogin(email: String) {
        
        MySQL?.fetchUser(email: email, completed: { [weak self] userExists, userName in
            guard let self = self else { return }

            if userExists {
                CoreData?.saveUser(email: email, name: userName)
                presenter?.presentData(response: .userIsChecked(valid: true, loginType: .apple))

            } else {
                presenter?.presentData(response: .userIsChecked(valid: false, loginType: .apple))
            }
        })
        
    }
    
    
    private func googleLogin(email: String) {
        
        MySQL?.fetchUser(email: email, completed: { [weak self] userExists, userName in
            guard let self = self else { return }

            if userExists {
                self.CoreData?.saveUser(email: email, name: userName)
                presenter?.presentData(response: .userIsChecked(valid: true, loginType: .google))
            } else {
                presenter?.presentData(response: .userIsChecked(valid: false, loginType: .google))
            }
        })
        
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
    
}
