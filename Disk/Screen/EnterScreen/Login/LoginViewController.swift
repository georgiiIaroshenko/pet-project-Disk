import SnapKit
import GoogleSignIn
import UIKit
import Combine

class LoginViewController: UIViewController, Storyboardable, CreatePlaceholder {
    
    var loginViewModel: LoginViewModel?
    private var cancellables = Set<AnyCancellable>()

    private let localized = "LocalizableLoginScreen"
    
    @IBOutlet weak var informButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak private var registrationOrAuthorizationLabel: UILabel!
    @IBOutlet weak private var textUserLoginField: UITextField!
    @IBOutlet weak private var errorLoginLabel: UILabel!
    @IBOutlet weak private var textUserPasswordField: UITextField!
    @IBOutlet weak private var textUserPasswordTwoField: UITextField!
    @IBOutlet weak private var buttonEnter: UIButton!
    @IBOutlet weak private var switchingRegistrationOrAuthorizationButton: UIButton!
    private lazy var googleEnterButton = GIDSignInButton()
    @IBOutlet weak var resetPassword: UIButton!
    
    private var isAuth = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    // MARK: - UI Configuration
    
    private func configureViewController() {
        navigationController?.isNavigationBarHidden = true
        configureViewElements()

    }
    
    private func configureViewElements() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "backImageView")!)
        configureRegOrAuthLabel()
        configureStackView()
        configureButtons()
        setupConstraints()
        isAuth ? configureForAuth() : configureForRegistration()
//        createBlurEffect()
    }
    private func createBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.alpha = 0
        view.addSubview(visualEffectView)
        
        let alphaValue: CGFloat = isAuth ? 0.4 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.5) {
                visualEffectView.alpha = alphaValue
            }
        }
    }
    
    private func configureForAuth() {
        textUserPasswordTwoField.isHidden = true
        googleEnterButton.isHidden = false
        
        registrationOrAuthorizationLabel.text = createPlaceholder(for: .registrationOrAuthorizationLabelAUTH, localized: localized)
        textUserLoginField.placeholder = createPlaceholder(for: .textUserLoginFieldAUTH, localized: localized)
        textUserPasswordField.placeholder = createPlaceholder(for: .textUserPasswordFieldAUTH, localized: localized)
        buttonEnter.setTitle(createPlaceholder(for: .buttonEnterAUTH, localized: localized), for: .normal)
        switchingRegistrationOrAuthorizationButton.setTitle(createPlaceholder(for: .switchingRegistrationOrAuthorizationButtonAUTH, localized: localized), for: .normal)
    }

    private func configureForRegistration() {
        textUserPasswordTwoField.isHidden = false
        googleEnterButton.isHidden = true
        
        registrationOrAuthorizationLabel.text = createPlaceholder(for: .registrationOrAuthorizationLabelREG, localized: localized)
        textUserLoginField.placeholder = createPlaceholder(for: .textUserLoginFieldREG, localized: localized)
        textUserPasswordField.placeholder = createPlaceholder(for: .textUserPasswordFieldREG, localized: localized)
        textUserPasswordTwoField.placeholder = createPlaceholder(for: .textUserPasswordFieldREG, localized: localized)
        buttonEnter.setTitle(createPlaceholder(for: .buttonEnterREG, localized: localized), for: .normal)
        switchingRegistrationOrAuthorizationButton.setTitle(createPlaceholder(for: .switchingRegistrationOrAuthorizationButtonREG, localized: localized), for: .normal)
    }
    
    private func configureRegOrAuthLabel() {
        registrationOrAuthorizationLabel.textColor = .black
        registrationOrAuthorizationLabel.textAlignment = .center
        registrationOrAuthorizationLabel.backgroundColor = UIColor(named: "whiteAlpha")
        registrationOrAuthorizationLabel.layer.masksToBounds = true
        registrationOrAuthorizationLabel.layer.cornerRadius = 15
    }
    
    private func configureStackView() {
        stackView.backgroundColor = UIColor.white.withAlphaComponent(0)
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 15
        
        configureTextFields()
        configureErrorLabel()
        configureEnterButton()
        configureGoogleEnterButton()
    }
    
    private func configureTextFields() {
        textUserLoginField.textColor = .black
        
        textUserPasswordField.textColor = .black
        textUserPasswordField.isSecureTextEntry = true
        
        textUserPasswordTwoField.textColor = .black
        textUserPasswordTwoField.isSecureTextEntry = true
    }
    
    private func configureErrorLabel() {
        bindViewModel()
        errorLoginLabel.textColor = .red
        errorLoginLabel.textAlignment = .center
    }
    
    private func bindViewModel() {
            loginViewModel?.$errorMessage
                .receive(on: DispatchQueue.main)
                .sink { [weak self] message in
                    self?.errorLoginLabel.text = message
                }
                .store(in: &cancellables)
        }
    
    private func configureEnterButton() {
        buttonEnter.setTitleColor(.black, for: .normal)
        buttonEnter.backgroundColor = UIColor(named: "whiteAlpha")
        buttonEnter.layer.masksToBounds = true
        buttonEnter.layer.cornerRadius = 15
        buttonEnter.addTarget(self, action: #selector(checkLoginAndPassword), for: .touchUpInside)
    }
    
    private func configureGoogleEnterButton() {
        googleEnterButton.style = .standard
        googleEnterButton.colorScheme = .dark
        googleEnterButton.addTarget(self, action: #selector(checkLoginAndPassword), for: .touchUpInside)
    }
    
    private func configureButtons() {
        switchingRegistrationOrAuthorizationButton.addTarget(self, action: #selector(toggleAuthMode), for: .touchUpInside)
        
        resetPassword.setTitle(createPlaceholder(for: .ressetPassword, localized: localized), for: .normal)
        resetPassword.addTarget(self, action: #selector(ressetPassword), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func checkLoginAndPassword() {
        loginViewModel?.checkLoginAndPassword(
            viewController: self,
            textFieldLogin: textUserLoginField.text ?? "",
            textFieldPassword: textUserPasswordField.text ?? "",
            textFieldTwoPassword: textUserPasswordTwoField.text ?? "",
            errorLoginLabel: errorLoginLabel.text ?? "",
            isAuth: isAuth
        )
    }
    
    @objc private func toggleAuthMode() {
        isAuth.toggle()
        isAuth ? configureForAuth() : configureForRegistration()
        errorLoginLabel.text = nil
    }
    
    @objc private func ressetPassword() {
        loginViewModel?.actionRessetPassword(viewController: self)
    }
    
    // MARK: - Setup Constraints
    
    
    private func setupConstraints() {
        registrationOrAuthorizationLabel.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.bottom.equalTo(stackView.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.width.equalTo(210)
            make.height.equalTo(250)
            make.center.equalToSuperview()
        }
        
        textUserLoginField.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        textUserPasswordField.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        textUserPasswordTwoField.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        buttonEnter.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        switchingRegistrationOrAuthorizationButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
        resetPassword.snp.makeConstraints { make in
            make.top.equalTo(switchingRegistrationOrAuthorizationButton.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
    }
}
