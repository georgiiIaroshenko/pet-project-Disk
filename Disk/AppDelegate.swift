//
//  AppDelegate.swift
//  Disk
//
//  Created by Георгий on 29.06.2024.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseCore
import GoogleSignIn


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        let navController = UINavigationController()
        navController.isNavigationBarHidden = true

        let appCoordinator = AppCoordinator(type: .app, navicationController: navController)
        appCoordinator.start()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }
}

