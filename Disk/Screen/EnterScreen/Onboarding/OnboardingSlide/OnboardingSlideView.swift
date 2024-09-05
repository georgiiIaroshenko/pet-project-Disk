import UIKit

class OnboardingSlideView: UIView {
    
    // MARK: -  create UIItem
    private let pageStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
     let pageButton: UIButton = {
       let buttom = UIButton()
        buttom.backgroundColor = .white
        buttom.titleLabel?.font = .systemFont(ofSize: 18)
        buttom.titleLabel?.numberOfLines = 0
        buttom.setTitle("", for: .normal)
        buttom.setTitleColor(.black, for: .normal)
        buttom.layer.masksToBounds = true
        buttom.layer.cornerRadius = 15
        buttom.translatesAutoresizingMaskIntoConstraints = false
        return buttom
    }()
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pageStackView)
        pageStackView.addArrangedSubview(pageLabel)
        pageStackView.addArrangedSubview(pageButton)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - recalled settings
    func setButtonText(_ text: String) {
        pageButton.setTitle(text, for: .normal)
        
    }
    
    func hideButton(vision: Bool) {
        pageButton.isHidden = vision
    }
    
    func setPageDescriptionText(text: String) {
        pageLabel.text = text
    }
    func setPageLabelTransform(transform: CGAffineTransform) {
        pageLabel.transform = transform
    }
    
    // MARK: - Setup Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            pageStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            pageStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            pageStackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            pageButton.heightAnchor.constraint(equalToConstant: 50),
            pageButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func configure(with setting: SettingOnboardingView, isLastSlide: Bool) {
        pageLabel.text = setting.description
            pageButton.isHidden = setting.hideButton
            if isLastSlide {
                pageButton.setTitle(setting.buttonText, for: .normal)
            }
        }
    
}
