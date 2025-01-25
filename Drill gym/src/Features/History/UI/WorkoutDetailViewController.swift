import UIKit

class WorkoutDetailViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.hidesBottomBarWhenPushed = false
        //(tabBarController as? TabBarController)?.setTabBarHidden(isHidden: false)
    }
}
