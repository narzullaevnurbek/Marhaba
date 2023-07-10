//
//  ImagesGridInteractor.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ImagesGridInteractorType {
    func makeRequest(request: ImagesGrid.Model.Request.RequestType)
}

class ImagesGridInteractor: ImagesGridInteractorType {

    var presenter: ImagesGridPresenterType?
    
    var MySQL: MySQLDB? = MySQLDB()

    func makeRequest(request: ImagesGrid.Model.Request.RequestType) {

        switch request {
        case .getHotelImages(let id):
            getHotelImages(id: id)
        case .getRoomImages(let id):
            getRoomImages(id: id)
        }
    }
    
    
    private func getHotelImages(id: Int) {
        
        MySQL?.select(requestURL: .images, selection: .hotelImages, model: [HotelImage].self, hotelID: id, completed: { [weak self] images in
            
            guard let self = self else {
                print("Error in getHotelsData function with [weak self]")
                return
            }
            
            guard let images = images else {
                print("Error while parsing hotel images in ImagesCollection")
                return
            }
            
            presenter?.presentData(response: .gotHotelImages(images: images))
        })
    }
    
    
    private func getRoomImages(id: Int) {
        
        MySQL?.select(requestURL: .images, selection: .roomImages, model: [RoomImage].self, roomID: id, completed: { [weak self] images in
            
            guard let self = self else {
                print("Error in getHotelsData function with [weak self]")
                return
            }
            
            guard let images = images else {
                print("Error while parsing room images in ImagesCollection")
                return
            }
            
            presenter?.presentData(response: .gotRoomImages(images: images))
        })
    }
  
}
