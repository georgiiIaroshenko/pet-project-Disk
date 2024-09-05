import Foundation

class Observable<T> {
    private var valueChanged: ((T) -> Void)?
    
    var value: T {
        didSet {
            valueChanged?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        valueChanged = closure
    }
}
