import UIKit

protocol OnboardingProtocol: AnyObject {
//    func nextScreen()
}

class OnboardingViewModel: OnboardingProtocol {
    
    var coordinator: OnboardingCoordinator
    private let userStorage = UserStorage.shared

    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }

    // Data for each slide
    var onboardingSettings: [Observable<SettingOnboardingView>] = [
        Observable(SettingOnboardingView(description: "Description for the first slide...", hideButton: true, buttonText: "")),
        Observable(SettingOnboardingView(description: "Description for the second slide...", hideButton: true, buttonText: "")),
        Observable(SettingOnboardingView(description: "Description for the third slide...", hideButton: false, buttonText: "Go to Registration"))
    ]
    
    func handleButtonPress() {
        userStorage.passedOnboarding = true
        coordinator.finish()
    }
}
