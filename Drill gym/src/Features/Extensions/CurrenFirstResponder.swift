import UIKit

extension UIResponder{
    private struct Static{
        static weak var responder: UIResponder?
    }
    
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(press), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func press() {
        Static.responder = self
    }
}

