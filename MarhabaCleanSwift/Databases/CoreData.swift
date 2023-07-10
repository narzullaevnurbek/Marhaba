//
//  CoreData.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 22/01/23.
//

import Foundation
import CoreData
import UIKit

enum UpdateSelection {
    case otpCode
    case cityID
}

class CoreDB {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveUser(email: String? = nil, name: String? = nil) {
        let newUser = User(context: context)
        newUser.email = email
        newUser.name = name
        newUser.otpCode = 0
        newUser.cityID = 1
        newUser.hotelID = 0
        
        do {
            try self.context.save()
        }
        catch {
            
        }
    }
    
    
    func fetchUser() -> User? {
        var users: User?
        
        do {
            users = try context.fetch(User.fetchRequest()).first
        }
        catch {
            
        }
        
        return users ?? nil
    }
    
    
    func update(value: Int64, selection: UpdateSelection) {
        
        var user: User!
        
        do {
            user = try context.fetch(User.fetchRequest()).first
        }
        catch {
            
        }
        
        switch selection {
        case .otpCode: user.otpCode = value
        case .cityID: user.cityID = value
        }
        
        do {
            try self.context.save()
        }
        catch {
            
        }
    }
    
    
    func deleteAll() {
        
        var users: [User]?
        
        do {
            users = try context.fetch(User.fetchRequest())
        }
        catch {
            
        }
        
        do {
            guard let data = users else {
                print("Error in deleteAll method in CoreData")
                return
            }
            for user in data {
                context.delete(user)
                try context.save()
            }
        }
        catch {
            
        }
    }
    
}
