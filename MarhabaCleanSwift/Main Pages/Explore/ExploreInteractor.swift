//
//  ExploreInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 21/06/23.
//

import Network
import UIKit
import Kingfisher

protocol ExploreInteractorType {
    func makeRequest(request: Explore.Model.Request.RequestType)
}

class ExploreInteractor: ExploreInteractorType {
    
    var presenter: ExplorePresenterType?
    
    var CoreData: CoreDB? = CoreDB()
    var MySQL: MySQLDB? = MySQLDB()
    let defaults = UserDefaults.standard
    
    
    func makeRequest(request: Explore.Model.Request.RequestType) {
        
        switch request {
        case .checkInternet:
            checkInternet()
        case .clearMemoryCache:
            ImageCache.default.clearMemoryCache()
        case .setSigned:
            defaults.setValue(true, forKey: "SignedIn")
        case .fetchHotels(let selection):
            fetchHotels(selection: selection)
        case .fetchDestinationHotels(let cityID, let cityName):
            fetchDestinationHotels(cityID: cityID, cityName: cityName)
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
    
    
    private func fetchHotels(selection: HotelSelectionType) {
        
        switch selection {
        case .bestAndAffordable:
            fetchBestAndAfforHotels()
        case .recommended:
            fetchRecommendedHotels()
        }
        
    }
    
    
    private func fetchBestAndAfforHotels() {
        
        guard let cityID = CoreData?.fetchUser()?.cityID else {
            print("Error in getHotelsData Explore cityId")
            return
        }
        
        MySQL?.select(requestURL: .hotels, selection: .bestAndAffordable, model: [Hotel].self, cityID: Int(cityID), completed: { [weak self] hotels in
            
            guard let self = self else {
                print("Error in getHotelsData function with [weak self]")
                return
            }
            
            guard let hotels = hotels else {
                print("Error while parsing best and affordable hotels in Explore")
                return
            }
            
            presenter?.presentData(response: .fetchedHotels(hotels: hotels, selection: .bestAndAffordable))
        })
    }
    
    
    private func fetchRecommendedHotels() {
        
        guard let cityID = CoreData?.fetchUser()?.cityID else {
            print("Error in getHotelsData Explore cityId")
            return
        }
        
        MySQL?.select(requestURL: .hotels, selection: .recommended, model: [Hotel].self, cityID: Int(cityID), completed: { [weak self] hotels in
            
            guard let self = self else {
                print("Error in getHotelsData function with [weak self]")
                return
            }
            
            guard let hotels = hotels else {
                print("Error while parsing recommended hotels in Explore")
                return
            }
            
            presenter?.presentData(response: .fetchedHotels(hotels: hotels, selection: .recommended))
        })
    }
    
    
    private func fetchDestinationHotels(cityID: Int, cityName: String) {
        
        MySQL?.select(requestURL: .hotels, selection: .byCity, model: [Hotel].self, cityID: cityID, completed: { hotels in
            guard let hotels = hotels else {
                print("Error while parsing hotels by city for destinations in ExploreInteractor")
                return
            }
            
            self.presenter?.presentData(response: .fetchedDestinationHotels(data: hotels, cityName: cityName))

//            self.navigationController?.pushViewController(HotelsList(hotelsData: hotels, pageTitle: cityName), animated: true)
//            self.spinner.stopAnimating()
        })
    }
    
}
