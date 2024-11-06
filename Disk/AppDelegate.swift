//
//  AppDelegate.swift
//  Disk
//
//  Created by Георгий on 29.06.2024.
//

import UIKit
import Firebase
import GoogleSignIn
import YandexLoginSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        // Настройка основного окна приложения
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()
        navController.isNavigationBarHidden = true
        
        let appCoordinator = AppCoordinator(type: .app, navicationController: navController)
        appCoordinator.start()
        
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Проверяем, что это наш redirect URL
        if url.absoluteString.starts(with: "yourapp://auth/callback") {
            if let code = extractAuthorizationCode(from: url) {
                // Теперь у вас есть код авторизации
                print("Authorization code: \(code)")
            }
        }
        return true
    }

    func extractAuthorizationCode(from url: URL) -> String? {
        // Разбираем URL и извлекаем код авторизации
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "code" })?.value
    }
}

