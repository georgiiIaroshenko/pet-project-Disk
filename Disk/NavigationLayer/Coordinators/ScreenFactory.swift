
import UIKit


struct ScreenFactory {
    // MARK: - Onboarding
    static func makeOnboardingFlow(coordinator: AppCoordinator, navicationController: UINavigationController,finishDelegate: CoordinatorFinishDelegate) {
        let onboardingCoordinator = OnboardingCoordinator(type: .onboarding, navicationController: navicationController, finishDelegate: finishDelegate)
        coordinator.addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    static func makeOnboardingScreen(coordinator: OnboardingCoordinator) -> OnboardingViewController {
        let vc = OnboardingViewController.createNaviObject()
        let viewModel = OnboardingViewModel(coordinator: coordinator)
        vc.onboardingViewModel = viewModel
        
        return vc
    }
    
    // MARK: - Login
    
    static func makeLoginFlow(coordinator: AppCoordinator, navicationController: UINavigationController,finishDelegate: CoordinatorFinishDelegate) {
        let loginCoordinator = LoginCoordinator(type: .login, navicationController: navicationController, finishDelegate: finishDelegate)
        coordinator.addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
    
    static func makeLoginScreen(coordinator: LoginCoordinator) -> LoginViewController {
        let vc = LoginViewController.createNaviObject()
        let viewModel = LoginViewModel(coordinator: coordinator)
        vc.loginViewModel = viewModel
        
        return vc
    }
    
    // MARK: - TabBar
    
    static func makeTabBarFlow(coordinator: AppCoordinator, finishDelegate: CoordinatorFinishDelegate) -> TabBarController {
        
            let profileNavigationController = UINavigationController()
            let profileCoordinator = ProfileCoordinator(type: .profile, navicationController: profileNavigationController)
            profileNavigationController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.badge.shield.checkmark.fill"), tag: 0)
            profileCoordinator.finishDelegate = finishDelegate
            profileCoordinator.start()
            
            let latterFileNavigationController = UINavigationController()
            let latterFileCoordinator = LatterFileCoordinator(type: .latterFile, navicationController: latterFileNavigationController)
            latterFileNavigationController.tabBarItem = UITabBarItem(title: "Последнее", image: UIImage(systemName: "doc.badge.arrow.up.fill"), tag: 1)
            latterFileCoordinator.finishDelegate = finishDelegate
            latterFileCoordinator.start()
            
            let allFileNavigationController = UINavigationController()
            allFileNavigationController.navigationBar.prefersLargeTitles = false
            let allFileCoordinator = AllFileCoordinator(type: .allFile, navicationController: allFileNavigationController)
            allFileNavigationController.tabBarItem = UITabBarItem(title: "Все файлы", image: UIImage(systemName: "externaldrive.fill.badge.checkmark"), tag: 2)
            allFileCoordinator.finishDelegate = finishDelegate
            allFileCoordinator.start()
            
            coordinator.addChildCoordinator(profileCoordinator)
            coordinator.addChildCoordinator(latterFileCoordinator)
            coordinator.addChildCoordinator(allFileCoordinator)
            
            let tabBarControllers = [profileNavigationController, latterFileNavigationController, allFileNavigationController]
            
            let tabBarController = TabBarController(tabBarControllers: tabBarControllers)
            
            return tabBarController
    }
    
    // MARK: - Profile
    
    static func makeProfileFlow(coordinator: AppCoordinator, navicationController: UINavigationController,finishDelegate: CoordinatorFinishDelegate) {
        let profileCoordinator = ProfileCoordinator(type: .profile, navicationController: navicationController, finishDelegate: finishDelegate)
        coordinator.addChildCoordinator(profileCoordinator)
        profileCoordinator.start()
    }
    
    static func makeProfileScreen(coordinator: ProfileCoordinator) -> ProfileViewController {
        let vc = ProfileViewController.createNaviObject()
        let viewModel = ProfileViewModel(coordinator: coordinator)
        vc.profileViewModel = viewModel
        
        return vc
    }
    // MARK: - LatterFile
    
    static func makeLatterFileFlow(coordinator: AppCoordinator, navicationController: UINavigationController,finishDelegate: CoordinatorFinishDelegate) {
        let latterFileCoordinator = LatterFileCoordinator(type: .latterFile, navicationController: navicationController, finishDelegate: finishDelegate)
        coordinator.addChildCoordinator(latterFileCoordinator)
        latterFileCoordinator.start()
    }
    
    static func makeLatterFileScreen(coordinator: LatterFileCoordinator) -> LatterFileViewController {
        let vc = LatterFileViewController.createNaviObject()
        let viewModel = LatterFileViewModel(coordinator: coordinator)
        vc.latterFileViewModel = viewModel
        
        return vc
    }
    // MARK: - AllFile
    
    static func makeAllFileFlow(coordinator: AppCoordinator, navicationController: UINavigationController,finishDelegate: CoordinatorFinishDelegate) {
        let allFileCoordinator = AllFileCoordinator(type: .allFile, navicationController: navicationController, finishDelegate: finishDelegate)
        coordinator.addChildCoordinator(allFileCoordinator)
        allFileCoordinator.start()
    }
    
    static func makeAllFileScreen(coordinator: AllFileCoordinator) -> AllFileViewController {
        let vc = AllFileViewController.createNaviObject()
        let viewModel = AllFileViewModel(coordinator: coordinator)
        vc.allFileViewModel = viewModel
        
        return vc
    }
}
