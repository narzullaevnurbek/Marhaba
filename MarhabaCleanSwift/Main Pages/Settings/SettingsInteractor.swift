//
//  SettingsInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Network

protocol SettingsInteractorType {
    func makeRequest(request: Settings.Model.Request.RequestType)
}

class SettingsInteractor: SettingsInteractorType {

    var presenter: SettingsPresenterType?
    
    var CoreData: CoreDB? = CoreDB()
    var MySQL: MySQLDB? = MySQLDB()
    let defaults = UserDefaults.standard

    func makeRequest(request: Settings.Model.Request.RequestType) {

        switch request {
        case .checkInternet:
            checkInternet()
        case .fetchUserFromLocalDB:
            guard let user = CoreData?.fetchUser() else { return }
            presenter?.presentData(response: .fetchedLocalUser(user: user))
        case .update(let value, let selection):
            CoreData?.update(value: Int64(value), selection: selection)
        case .eraseCoreData:
            CoreData?.deleteAll()
        case .logOut:
            self.defaults.set(false, forKey: "SignedIn")
        case .deleteAccount:
            if let userEmail = self.CoreData?.fetchUser()?.email {
                self.MySQL?.deleteUser(email: userEmail)
            }
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
  
}
