import UIKit

class CreateWorkoutViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        configurateNavigationItem()
    }
    
    private func configurateNavigationItem() {
        guard let navigationController = navigationController else {
            return
        }
        
        navigationItem.title = NSLocalizedString("Create workout", comment: "reate workout")
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemYellow
    }
    
    @objc private func backButton() {
        guard let navigationController = navigationController else{return}
        navigationController.popViewController(animated: true)
    }
}

