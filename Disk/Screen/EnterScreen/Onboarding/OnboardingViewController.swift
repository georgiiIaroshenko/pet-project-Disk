import UIKit

// MARK: - OnboardingViewController
 final class OnboardingViewController: UIViewController, Storyboardable {
    
    // MARK: - Properties
    var onboardingViewModel: OnboardingViewModel?
    
    // MARK: - UI Elements
     let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
     let backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        backImageView.image = UIImage(named: "backImageView")
        backImageView.contentMode = .scaleAspectFill
        return backImageView
    }()
    
     let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var slides = [OnboardingSlideView]()
    private var sliderManager: OnboardingSliderManager?
     
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupViews()
        setConstraints()
        slides = createSliders()
        sliderManager = OnboardingSliderManager(viewController: self)
        setDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sliderManager?.setupSliderScrollView(sliders: slides)

    }
    
    // MARK: - OnboardingSetup Protocol Methods
    func setDelegates() {
        scrollView.delegate = self
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        scrollView.addSubview(backImageView)
    }
     func createSliders() -> [OnboardingSlideView] {
             return onboardingViewModel?.onboardingSettings.enumerated().map { (index, observable) -> OnboardingSlideView in
                 let slideView = OnboardingSlideView()
                 bindViewModel(to: slideView, setting: observable, isLastSlide: index == 2)
                 return slideView
             } ?? []
         }
     
     private func bindViewModel(to view: OnboardingSlideView, setting: Observable<SettingOnboardingView>?, isLastSlide: Bool = false) {
         setting?.bind { [weak self] setting in
             guard let self = self else { return }
             DispatchQueue.main.async {
                 view.configure(with: setting, isLastSlide: isLastSlide)
                 if isLastSlide {
                     view.pageButton.addTarget(self, action: #selector(self.buttonPress), for: .touchUpInside)
                 }
             }
         }
     }
     
    @objc func buttonPress() {
        onboardingViewModel?.handleButtonPress()
    }
    
    // MARK: - Layout Constraints
    func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            backImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            backImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            backImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           sliderManager?.updatePageControl(for: scrollView)
       }
}
