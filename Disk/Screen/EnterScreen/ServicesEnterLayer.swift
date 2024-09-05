//
//  ServicesEnterLayer.swift
//  Disk
//
//  Created by Георгий on 08.08.2024.
//

import Foundation


class UserStorage {
    
    static let shared = UserStorage()
    
    var passedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "passedOnboarding") }
        
        set { UserDefaults.standard.set(newValue, forKey: "passedOnboarding") }
    }
    
    var firebaseUserId: String {
        get { UserDefaults.standard.string(forKey: "firebaseUserId") ?? ""}
        
        set { UserDefaults.standard.set(newValue, forKey: "firebaseUserId") }
    }
}
