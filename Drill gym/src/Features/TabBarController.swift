import UIKit

class TabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateTabBar()
    }
    
    private func configurateTabBar() {
        let home = HomeViewController()
        let calendar = CalendarViewController()
        let history = HistoryViewController()
        
        home.tabBarItem.title = NSLocalizedString("Home", comment: "Home screen")
        home.tabBarItem.image = UIImage(systemName: "house.fill")
        
        calendar.tabBarItem.title = NSLocalizedString("Calendar", comment: "Calendar screen")
        calendar.tabBarItem.image = UIImage(systemName: "calendar")
        
        history.tabBarItem.title = NSLocalizedString("History", comment: "History screen")
        history.tabBarItem.image = UIImage(systemName: "clock.fill")
        
        let homeTab = UINavigationController(rootViewController: home)
        let calendarTab = UINavigationController(rootViewController: calendar)
        let historyTab = UINavigationController(rootViewController: history)
        
        tabBar.tintColor = .systemYellow
        tabBar.backgroundColor = .systemGray
        
        setViewControllers([homeTab, calendarTab, historyTab], animated: true)
    }
}
