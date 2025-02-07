import UIKit

extension UIViewController: @retroactive UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
