import UIKit
protocol ActivityViewFullScreen {
    func showActivityIndicator(view: UIView)
    func hideActivityIndicator()
}


extension ActivityViewFullScreen {
    func showActivityIndicator(view: UIView) {
        ActivityFactory.shared.showActivityIndicator(in: view)
    }
    func hideActivityIndicator() {
        ActivityFactory.shared.hideActivityIndicator()
    }
}
