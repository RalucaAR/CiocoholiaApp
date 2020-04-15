//
//  UserDefaultsHelper.swift
//  Project
//
//  Created by Inovium Digital Vision on 13/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import Foundation
import CoreData

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case userEmail
    }
    
    func setIsLoggedIn (value: Bool){
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func setLoggedInUserEmail(value: String){
        set(value, forKey: UserDefaultsKeys.userEmail.rawValue)
        synchronize()
    }
    
    func getIsLoggedIn () -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func getLoggedInUserEmail() -> String {
        return string(forKey: UserDefaultsKeys.userEmail.rawValue) ?? ""
    }
}
