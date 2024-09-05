//
//  ProfileCoordinator.swift
//  Disk
//
//  Created by Георгий on 07.08.2024.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    
    private let factory = ScreenFactory.self

    override func start() {
        showProfile()
    }
    
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
//        (finishDelegate as? AppCoordinator)?.finishTabBarFlow()
        print("AppCoordinator - profile - finish!")
    }
}

private extension ProfileCoordinator {
    func showProfile() {
        let vc = factory.makeProfileScreen(coordinator: self)
        navicationController?.pushViewController(vc, animated: false)
    }
}
