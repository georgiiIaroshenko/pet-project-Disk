//
//  OnboardingCoordinator.swift
//  Disk
//
//  Created by Георгий on 06.08.2024.
//

import Foundation

class OnboardingCoordinator: Coordinator {
    
    private let factory = ScreenFactory.self
    
    override func start() {
        showOnboarding()
    }
    
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        print("AppCoordinator finish!")
    }
}

private extension OnboardingCoordinator {
    func showOnboarding() {
        let vc = factory.makeOnboardingScreen(coordinator: self)
        navicationController?.pushViewController(vc, animated: false)
    }
}
