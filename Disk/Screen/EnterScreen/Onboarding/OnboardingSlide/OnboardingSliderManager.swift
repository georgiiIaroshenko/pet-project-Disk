import UIKit

class OnboardingSliderManager {
    
    private weak var viewController: OnboardingViewController?
    
    init(viewController: OnboardingViewController) {
        self.viewController = viewController
    }
    
    func setupSliderScrollView(sliders: [OnboardingSlideView]) {
        guard let viewController = viewController else { return }
        
        viewController.scrollView.contentSize = CGSize(width: viewController.view.frame.width * CGFloat(sliders.count),
                                                       height: viewController.view.frame.height)
        
        for i in 0..<sliders.count {
            sliders[i].frame = CGRect(x: viewController.view.frame.width * CGFloat(i),
                                      y: 0,
                                      width: viewController.view.frame.width,
                                      height: viewController.view.frame.height)
            viewController.scrollView.addSubview(sliders[i])
        }
    }
    
    func updatePageControl(for scrollView: UIScrollView) {
        guard let viewController = viewController else { return }
        
        let pageIndex = round(scrollView.contentOffset.x / viewController.view.frame.width)
        viewController.pageControl.currentPage = Int(pageIndex)
        
        let maxHorizontalOffset = scrollView.contentSize.width - viewController.view.frame.width
        let percentHorizontalOffset = scrollView.contentOffset.x / maxHorizontalOffset
        
        let firstIndex = max(0, min(1, percentHorizontalOffset / 0.5))
        let secondIndex = max(0, min(1, (percentHorizontalOffset - 0.5) / 0.5))
        
        viewController.slides[0].setPageLabelTransform(transform: CGAffineTransform(scaleX: 1 - firstIndex, y: 1 - firstIndex))
        viewController.slides[1].setPageLabelTransform(transform: CGAffineTransform(scaleX: firstIndex, y: firstIndex))
        viewController.slides[1].setPageLabelTransform(transform: CGAffineTransform(scaleX: 1 - secondIndex, y: 1 - secondIndex))
        viewController.slides[2].setPageLabelTransform(transform: CGAffineTransform(scaleX: secondIndex, y: secondIndex))
    }
}
