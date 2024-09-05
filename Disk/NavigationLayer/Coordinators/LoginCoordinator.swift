//
//  LoginCoordinator.swift
//  Disk
//
//  Created by Георгий on 06.08.2024.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    
    private let factory = ScreenFactory.self
    
    override func start() {
        showLogin()
    }
    
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        print("AppCoordinator - login - finish!")
    }
}

private extension LoginCoordinator {
    func showLogin() {
        let vc = factory.makeLoginScreen(coordinator: self)
        navicationController?.pushViewController(vc, animated: false)
    }
}
