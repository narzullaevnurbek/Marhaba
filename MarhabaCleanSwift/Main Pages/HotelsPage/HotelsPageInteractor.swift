//
//  HotelsPageInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Network

protocol HotelsPageInteractorType {
    func makeRequest(request: HotelsPage.Model.Request.RequestType)
}

class HotelsPageInteractor: HotelsPageInteractorType {
    
    var CoreData: CoreDB? = CoreDB()
    var MySQL: MySQLDB? = MySQLDB()
    let defaults = UserDefaults.standard

    var presenter: HotelsPagePresenterType?

    func makeRequest(request: HotelsPage.Model.Request.RequestType) {

        switch request {
        case .checkInternet:
            checkInternet()
        case .getHotel(let hotelID):
            getHotel(hotelID: hotelID)
        case .getAmens(let hotelID):
            getAmens(hotelID: hotelID)
        case .rooms(let hotelID):
            getRooms(hotelID: hotelID)
        case .roomImages(let hotelID):
            getRoomImages(hotelID: hotelID)
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
    
    
    private func getHotel(hotelID: Int) {
        
        MySQL?.select(requestURL: .singleHotel, selection: .hotelItself, model: [Hotel].self, hotelID: hotelID, completed: { [weak self] hotel in
            
            guard let self = self else {
                print("Error in getHotelsData function with [weak self]")
                return
            }
            
            guard let hotel = hotel else {
                print("Error while parsing single hotel in HotelsPage")
                return
            }
            
            presenter?.presentData(response: .gotHotel(hotel: hotel))
        })
    }
    
    
    private func getAmens(hotelID: Int) {
        
        MySQL?.select(requestURL: .singleHotel, selection: .amenities, model: [Amenities].self, hotelID: hotelID, completed: { [weak self] amenities in
            
            guard let self = self else {
                print("Error in getHotelsData function with [weak self]")
                return
            }
            
            guard let amenities = amenities else {
                print("Error while parsing amenities in HotelsPage")
                return
            }
            
            presenter?.presentData(response: .gotAmens(amens: amenities))
        })
    }
    
    
    private func getRooms(hotelID: Int) {
        
        MySQL?.select(requestURL: .singleHotel, selection: .rooms, model: [HotelRooms].self, hotelID: hotelID, completed: { [weak self] rooms in
            
            guard let self = self else {
                print("Error in getHotelsData function with [weak self]")
                return
            }
            
            guard let rooms = rooms else {
                print("Error while parsing rooms in HotelsPage")
                return
            }
            
            presenter?.presentData(response: .gotRooms(rooms: rooms))
        })
    }
    
    
    private func getRoomImages(hotelID: Int) {
        
        MySQL?.select(requestURL: .images, selection: .roomImages, model: [RoomImage].self, hotelID: hotelID, completed: { [weak self] images in
            
            guard let self = self else {
                print("Error in getHotelsData function with [weak self]")
                return
            }
            
            guard let images = images else {
                print("Error while parsing rooms' images in HotelsPage")
                return
            }
            
            presenter?.presentData(response: .gotRoomImages(roomImages: images))
        })
    }
  
}
