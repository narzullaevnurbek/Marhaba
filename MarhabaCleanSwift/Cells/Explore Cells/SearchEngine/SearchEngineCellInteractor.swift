//
//  SearchEngineInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 10/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchEngineCellInteractorType {
    func makeRequest(request: SearchEngine.Model.Request.RequestType)
}

class SearchEngineCellInteractor: SearchEngineCellInteractorType {

    var presenter: SearchEngineCellPresenterType?
    
    var CoreData: CoreDB? = CoreDB()
    var MySQL: MySQLDB? = MySQLDB()
    var defaults = UserDefaults.standard

    func makeRequest(request: SearchEngine.Model.Request.RequestType) {

        switch request {
        case .searchHotels(let city, let nightsCount, let adults, let children, let rooms):
            searchHotels(city: city, nightsCount: nightsCount, adults: adults, children: children, rooms: rooms)
        case .fetchUserFromLocalDB:
            guard let user = CoreData?.fetchUser() else { return }
            presenter?.presentData(response: .fetchedLocalUser(user: user))
        }
    }
    
    
    private func searchHotels(city: String, nightsCount: Int, adults: Int, children: Int, rooms: Int) {
        
        MySQL?.searchHotels(city: city, nightsCount: nightsCount, adults: adults, children: children, rooms: rooms, completed: { hotelsData in
            
            self.presenter?.presentData(response: .gotSearchedHotels(data: hotelsData))
        })
    }
  
}
