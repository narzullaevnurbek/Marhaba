//
//  SkipInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 20/06/23.
//

import Network

protocol SkipInteractorType {
    func makeRequest(request: Skip.Model.Request.RequestType)
}

class SkipInteractor: SkipInteractorType {
    
    var presenter: SkipPresenterType?
    var CoreData: CoreDB? = CoreDB()
    
    func makeRequest(request: Skip.Model.Request.RequestType) {
        
        switch request {
        case .checkInternet:
            checkInternet()
        case .saveUser(userName: let userName):
            CoreData?.saveUser(name: userName)
        }
        
    }
    
    
    func checkInternet() {
        let queue = DispatchQueue(label: "Network")
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in

            if path.status != .satisfied {
                self.presenter?.presentData(response: .internetResponse(isConnected: false))
            } else {
                self.presenter?.presentData(response: .internetResponse(isConnected: true))
            }

        }
        monitor.start(queue: queue)
    }
}
