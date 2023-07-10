//
//  MySQLDB.swift
//  HotelsUz
//
//  Created by Narzullaev Nurbek on 12/03/23.
//

import Foundation
import Alamofire

enum Selection {
    case bestAndAffordable
    case recommended
    case byCity
    case hotelItself
    case amenities
    case roomImages
    case hotelImages
    case rooms
    
    
    var params: String {
        switch self {
        case .bestAndAffordable: return "bestAndAffordable"
        case .recommended: return "recommended"
        case .byCity: return "byCity"
        case .hotelItself: return "hotelItself"
        case .amenities: return "amenities"
        case .roomImages: return "roomImages"
        case .hotelImages: return "hotelImages"
        case .rooms: return "hotelRooms"
        }
    }
}


enum RequestURL {
    case singleHotel
    case hotels
    case images
    
    var url: String {
        switch self {
        case .singleHotel: return "getSingleHotelData.php"
        case .hotels: return "getData.php"
        case .images: return "getImages.php"
        }
    }
}



class MySQLDB {
    
    let headers: HTTPHeaders = [ "Accept": "application/json", ]
    
    var serverDomain = "https://cyclone.uz/"
    
    
    func saveUser(name: String, email: String) {
        
        let url = serverDomain + "insertUser.php"
        
        let params = [
            "userID": "\(userID)",
            "name": "\(name)",
            "email": "\(email)"
        ]
        
        AF.request(url, method: .post, parameters: params, headers: headers).validate().responseJSON {  response in
            
            DispatchQueue.global().async {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    let jsonData = jsonResponse as! NSDictionary
                    let result = jsonData["response"] as! String
                    print(result)
                }
                catch {
                    print("Error while saving an user")
                }
            }
        }
    }
    
    
    func fetchUser(email: String, completed: @escaping (Bool, String) -> Void) {
        
        let url = serverDomain + "fetchUser.php"
        
        let params = [
            "email": "\(email)"
        ]
        
        
        AF.request(url, method: .post, parameters: params, headers: headers).validate().responseJSON {  response in
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: response.data!, options: [])
                let jsonData = jsonResponse as! NSDictionary
                let result = jsonData["response"] as! String
                if result == "exists" {
                    let name = jsonData["name"] as! String
                    completed(true, name)
                } else {
                    completed(false, "")
                }
            }
            catch {
                print("Error while checking an user")
            }
        }
    }
    
    
    func deleteUser(email: String) {
        
        let url = serverDomain + "deleteUser.php"
        
        let params = [
            "email": "\(email)"
        ]
        
        AF.request(url, method: .post, parameters: params, headers: headers).validate().responseJSON {  response in
            
            DispatchQueue.global().async {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    let jsonData = jsonResponse as! NSDictionary
                    let result = jsonData["response"] as! String
                    print(result)
                }
                catch {
                    print("Error while saving an user")
                }
            }
        }
    }
    
    
    func select<T: Decodable>(requestURL: RequestURL, selection: Selection, model: T.Type, hotelID: Int = 0, roomID: Int = 0, cityID: Int = 0, completed: @escaping (T?) -> Void) {
        
        let params: [String: Any] = [
            "selectionType": selection.params,
            "hotelID": hotelID,
            "roomID": roomID,
            "cityID": cityID
        ]
        
        let url = serverDomain + requestURL.url
        
        AF.request(url, method: .post, parameters: params, headers: headers).validate().responseJSON {  response in
            guard let data = response.data else { return }
            
            let decoded = self.decodeJSON(model: model.self, from: data)
            completed(decoded)
        }
    }
    
    
    func decodeJSON<T: Decodable>(model: T.Type, from: Data?) -> T? {
        
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let hotel = try decoder.decode(model.self, from: data)
            return hotel
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    func searchHotels(city: String, nightsCount: Int, adults: Int, children: Int, rooms: Int, completed: @escaping ([Hotel]) -> Void) {
        let url = "https://cyclone.uz/searchEngine.php"
        
        let params: [String: Any] = [
            "city": city,
            "nightsCount": nightsCount,
            "adults": adults,
            "children": children,
            "rooms": rooms,
        ]
        
        AF.request(url, method: .post, parameters: params, headers: headers).validate().responseJSON {  response in
            
            let decoder = JSONDecoder()
            
            do {
                let hotels = try decoder.decode([Hotel].self, from: response.data!)
                completed(hotels)
            }
            catch {
                print(error.localizedDescription + "getHotelImages")
            }
        }
    }
        
}
