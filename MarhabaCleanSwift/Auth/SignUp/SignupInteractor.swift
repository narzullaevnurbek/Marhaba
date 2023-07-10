//
//  SignUpInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 19/06/23.
//

import Foundation
import Network

protocol SignupInteractorType {
    func makeRequest(request: Signup.Model.Request.RequestType)
}

class SignupInteractor: SignupInteractorType {
    
    var presenter: SignupPresenterType?
    
    var CoreData: CoreDB? = CoreDB()
    var MySQL: MySQLDB? = MySQLDB()
    var Networking: NetworkManager? = NetworkManager()
    
    
    func makeRequest(request: Signup.Model.Request.RequestType) {
        
        switch request {
        case .checkInternet:
            checkInternet()
        case .saveDemoAccount(let email, let name):
            CoreData?.saveUser(email: email, name: name)
        case .checkUser(let email, let name):
            checkUserInServer(email: email, name: name)
        case .googleSignup(let email, let name):
            googleSignup(email: email, name: name)
        case .appleSignup(let email, let name):
            appleSignup(email: email, name: name)
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
    
    
    func checkUserInServer(email: String, name: String) {
        
        MySQL?.fetchUser(email: email, completed: { [weak self] userExists, userName in

            guard let self = self else { return }

            if !userExists {
                Networking?.sendOTP(email: email)
                CoreData?.saveUser(email: email, name: name)
                presenter?.presentData(response: .userIsChecked(valid: true, signupType: .email))
            } else {
                presenter?.presentData(response: .userIsChecked(valid: false, signupType: .email))
            }
        })
    }
    
    
    private func appleSignup(email: String, name: String) {
        
        MySQL?.fetchUser(email: email, completed: { [weak self] userExists, userName in
            guard let self = self else { return }

            if !userExists {
                CoreData?.saveUser(email: email, name: name)
                presenter?.presentData(response: .userIsChecked(valid: true, signupType: .apple))

            } else {
                presenter?.presentData(response: .userIsChecked(valid: false, signupType: .apple))
            }
        })
        
    }
    
    
    private func googleSignup(email: String, name: String) {
        
        MySQL?.fetchUser(email: email, completed: { [weak self] userExists, userName in
            guard let self = self else { return }

            if !userExists {
                self.CoreData?.saveUser(email: email, name: name)
                presenter?.presentData(response: .userIsChecked(valid: true, signupType: .google))
            } else {
                presenter?.presentData(response: .userIsChecked(valid: false, signupType: .google))
            }
        })
        
    }
    
}
