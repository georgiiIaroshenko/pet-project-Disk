import UIKit
import FirebaseAuth
import FirebaseCore

class AppCoordinator: Coordinator {
    
    private var userStorage = UserStorage.shared
    var googleUser: Storage?
    private let factory = ScreenFactory.self

    private var isMainFlowShown = false
    private var isLoginFlowShown = false
    
    private func showMainFlowIfNeeded() {
        guard !isMainFlowShown else { return }
        isMainFlowShown = true
        navicationController?.viewControllers.removeAll()
        showMainFlow()
    }
    
    private func showLoginFlowIfNeeded() {
        guard !isLoginFlowShown else { return }
        isLoginFlowShown = true
        navicationController?.viewControllers.removeAll()
        showLoginFlow()
    }
    
    override func start() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                if self.userStorage.passedOnboarding {
                    self.showLoginFlowIfNeeded()
                } else {
                    self.showOnboardingFlow()
                }
            } else {
                self.showMainFlowIfNeeded()
            }
        }
    }
    
    override func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        print("AppCoordinator finish!")
    }
}
// MAARK: - Navigation methods
private extension AppCoordinator {
    func showOnboardingFlow() {
        guard let navicationController else { return }
        factory.makeOnboardingFlow(coordinator: self, navicationController: navicationController, finishDelegate: self)
    }
    
    func showLoginFlow() {
        guard let navicationController else { return }
        factory.makeLoginFlow(coordinator: self, navicationController: navicationController, finishDelegate: self)
    }
    
    func showMainFlow() {
        guard let navicationController else { return }
        
        let tabBarController = factory.makeTabBarFlow(coordinator: self, finishDelegate: self)
        navicationController.pushViewController(tabBarController, animated: true)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
        switch childCoordinator.type {
        case .onboarding:
            navicationController?.viewControllers.removeAll()
            showLoginFlow()
        case .login:
            self.showMainFlowIfNeeded()
        case .app:
            return
        case .profile:
            if let tabBarController = navicationController?.viewControllers.first(where: { $0 is UITabBarController }) as? UITabBarController {
                tabBarController.viewControllers?.forEach { navController in
                    (navController as? UINavigationController)?.viewControllers.removeAll()
                }
            }
            navicationController?.viewControllers.removeAll(where: { $0 is UITabBarController })
            isMainFlowShown = false
            print("  isMainFlowShown = false ")
            isLoginFlowShown = false
            showLoginFlowIfNeeded()
        default:
            navicationController?.popToRootViewController(animated: false)
        }
    }
}
