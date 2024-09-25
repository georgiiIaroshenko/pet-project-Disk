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
import YandexLoginSDK


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            try YandexLoginSDK.shared.activate(with: "7b8b94d6684e4966b708c19fcf5df8cf")
        } catch {
            print("Failed to activate Yandex Login SDK: \(error.localizedDescription)")
        }
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return YandexLoginSDK.shared.tryHandleOpenURL(url)
    }
}

