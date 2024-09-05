import UIKit

protocol Storyboardable {
    static func createNaviObject() -> Self
}

extension Storyboardable where Self: UIViewController {
    static func createNaviObject() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: id) as! Self
    }
}


