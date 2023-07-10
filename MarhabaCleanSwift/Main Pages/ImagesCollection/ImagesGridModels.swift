//
//  ImagesGridModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum ImagesGrid {
    
    enum ImagesGridSelection {
        case hotel
        case room
    }
   
    enum Model {
        struct Request {
            enum RequestType {
                case getHotelImages(id: Int)
                case getRoomImages(id: Int)
            }
        }
            
        struct Response {
            enum ResponseType {
                case gotHotelImages(images: [HotelImage])
                case gotRoomImages(images: [RoomImage])
            }
        }
            
        struct ViewModel {
            enum ViewModelData {
                case receiveHotelImages(images: [HotelImage])
                case receiveRoomImages(images: [RoomImage])
            }
        }
    }
  
}
