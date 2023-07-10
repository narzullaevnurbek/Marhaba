//
//  HotelsListInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Network

protocol HotelsListInteractorType {
  func makeRequest(request: HotelsList.Model.Request.RequestType)
}

class HotelsListInteractor: HotelsListInteractorType {

  var presenter: HotelsListPresenterType?
  
    func makeRequest(request: HotelsList.Model.Request.RequestType) {
        
        switch request {
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
                    self.presenter?.presentData(response: .internetResponse(isConnected: false))
                }
            }
            
        }
        monitor.start(queue: queue)
    }
}
