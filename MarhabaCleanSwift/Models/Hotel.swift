//
//  Hotel.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 17/04/23.
//

import Foundation

struct Hotel: Decodable {
    var id: Int
    var name: String
    var price: Int
    var address: String
    var description: String
    var rating: Double
    var thumbImageUrl: String
    let latitude: Double
    let longitude: Double
    var distance: String
    var url: String
    var cityId: Int
    var distId: Int
}
