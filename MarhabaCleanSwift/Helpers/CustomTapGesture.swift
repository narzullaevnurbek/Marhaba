//
//  HTapGesture.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 13/03/23.
//

import UIKit

class CustomTapGesture: UITapGestureRecognizer {
    var hotelID: Int?
    var desc: String?
    var roomID: Int?
    var hotelsData: [Hotel]?
    var pageTitle: String?
    var city: String?
    var nightsCount: Int?
    var adults: Int?
    var children: Int?
    var rooms: Int?
    var cityID: Int?
}
