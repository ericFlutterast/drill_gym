import UIKit

class AddWorkoutOnCalendarViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        configurateNavigationItem()
    }
    
    private func configurateNavigationItem(){
        navigationItem.title = NSLocalizedString("Add workout", comment: "add workout")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(createWorkout))
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemYellow
    }
    
    @objc private func createWorkout() {
        print("move to create workout screen")
    }
    
    @objc private func backButton() {
        guard let navigationController = navigationController else{return}
        navigationController.popViewController(animated: true)
    }
}
