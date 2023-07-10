//
//  MySQL.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 28/01/23.
//

import Foundation
import Alamofire
import UIKit

class NetworkManager {
    
    var CoreData: CoreDB? = CoreDB()
    let cache = NSCache<NSString, UIImage>()
    
    let headers: HTTPHeaders = [
        "Accept": "application/json",
    ]
    
    
    func sendOTP(email: String) {
        let url = "https://malarious-teaspoons.000webhostapp.com/sendEmail.php"
        var otpCode = Int64()
        let params = [ "email": "\(email)" ]
        
        AF.request(url, method: .post, parameters: params, headers: headers).validate().responseJSON { [weak self] response in
            
            guard let self = self else { return }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: response.data!, options: [])
                let jsonData = jsonResponse as! NSDictionary
                otpCode = jsonData["otp"] as! Int64
                self.CoreData?.update(value: otpCode, selection: .otpCode)
            }
            catch {
                print("Error while sending OTP")
            }
        }
    }
    
    
    func downloadImage(from url: String, completed: @escaping (UIImage) -> Void) {
            
        let cacheKey = NSString(string: url)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let imageURL = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
            }
        }
        task.resume()
    }
    
    
    deinit {
        print("NetworkManager is terminated")
    }
}

