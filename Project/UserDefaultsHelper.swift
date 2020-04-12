//
//  UserDefaultsHelper.swift
//  Project
//
//  Created by Inovium Digital Vision on 13/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import Foundation


extension UserDefaults {
    enum UserDefaultsKeys: String {
        case isLoggedIn
    }
    
    func setIsLoggedIn (value: Bool){
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func getIsLoggedIn () -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
}
