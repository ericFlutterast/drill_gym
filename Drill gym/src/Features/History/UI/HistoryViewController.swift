import UIKit

class HistoryViewController: UIViewController{
    //private var isHidden: Bool = false
    
    lazy var button = {
        let button = UIButton()
        button.setTitle("Next page", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
     
        
        configurateUI()
    }
    
    private func configurateUI() {
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 80),
            button.widthAnchor.constraint(equalToConstant: 300),
        ]
        )
    }
       
    @objc func buttonHandler()    {
        guard let navigationController = self.navigationController else{
            print("self controller has not exist")
            return
        }

        self.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(WorkoutDetailViewController() , animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
