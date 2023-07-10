//
//  HotelsPageModels.swift
//  MarhabaCleanSwift
//
//  Created by Narzullaev Nurbek on 09/07/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum HotelsPage {
   
    enum Model {
        struct Request {
            enum RequestType {
                case checkInternet
                case getHotel(hotelID: Int)
                case getAmens(hotelID: Int)
                case rooms(hotelID: Int)
                case roomImages(hotelID: Int)
            }
        }
            
        struct Response {
            enum ResponseType {
                case internetResponse(isConnected: Bool)
                case gotHotel(hotel: [Hotel])
                case gotAmens(amens: [Amenities])
                case gotRooms(rooms: [HotelRooms])
                case gotRoomImages(roomImages: [RoomImage])
            }
        }
            
        struct ViewModel {
            enum ViewModelData {
                case internetStatus(isConnected: Bool)
                case receiveHotel(hotel: [Hotel])
                case receiveAmens(amens: [Amenities])
                case receiveRooms(rooms: [HotelRooms])
                case receiveRoomImages(roomImages: [RoomImage])
            }
        }
    }
  
}
