import UIKit

struct AppNavigation{
    private static let routes: [Routes: UIViewController] = [
        .home : HomeViewController(),
        .calendar : CalendarViewController(),
        .history : HistoryViewController(),
        .addWorkout : AddWorkoutOnCalendarViewController(calendarStateContext: Dependencies.shared.calendarStateContext),
        .createWorkout: CreateWorkoutViewController()
    ]
    
    static func getRout(path: Routes) -> UIViewController {
        guard let currentController = routes[path] else {
            fatalError("Route doest exist")
        }
        return currentController
    }
}

enum Routes: String{
    case home = "/"
    case calendar
    case history
    case addWorkout
    case createWorkout
}
