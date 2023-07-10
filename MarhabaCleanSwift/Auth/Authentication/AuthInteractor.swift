//
//  AuthInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 19/06/23.
//

import Foundation
import Network

protocol AuthInteractorType {
    func makeRequest(request: Auth.Model.Request.RequestType)
}

class AuthInteractor: AuthInteractorType {
    
    var presenter: AuthPresenterType?
    var CoreData: CoreDB? = CoreDB()
    
    
    func makeRequest(request: Auth.Model.Request.RequestType) {
        
        switch request {
        case .deleteUserData:
            CoreData?.deleteAll()
        case .checkInternet:
            checkInternet()
        }
        
    }
    
    
    func checkInternet() {
        let queue = DispatchQueue(label: "Network")
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in

            if path.status != .satisfied {
                DispatchQueue.main.async {
                    //self.navigationController?.pushViewController(NetworkError(), animated: false)
                    self.presenter?.presentData(response: .internetResponse(isConnected: false))
                }
            }

        }

        monitor.start(queue: queue)
    }
    
}
