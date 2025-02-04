import UIKit

class CalendarViewController: UIViewController{
    private var selectDates = [Date?: UICalendarView.Decoration]()
    
    private lazy var calendarView = {
        let calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.tintColor = .systemYellow
        calendarView.delegate = self
        
        
        
        let selectionDelegate = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selectionDelegate
        
        return calendarView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        configurateController()
    }
    
    @objc private func addWorkoutHandler() {
        print("tapped")
    }
    
    private func configurateController() {
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
        ])
    }
    
    private func add(decoration: UICalendarView.Decoration, on date: Date) {
        let dateComponents = Calendar.current.dateComponents(
                [.calendar, .year, .month, .day ],
                from: date
            )
        
        if selectDates.keys.contains(dateComponents.date){
            selectDates.removeValue(forKey: dateComponents.date)
        }else{
            selectDates[dateComponents.date] = decoration
        }

        calendarView.reloadDecorations(
            forDateComponents: [dateComponents],
            animated: true
        )
          
    }
}

extension CalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let navController = navigationController else{
            return
        }
        
        //MARK: - transition on create workout screen
        self.hidesBottomBarWhenPushed = true
        let addWorkoutOnCalendarWorkout = AddWorkoutOnCalendarViewController()
        addWorkoutOnCalendarWorkout.selectedDate = dateComponents
        navController.pushViewController(addWorkoutOnCalendarWorkout, animated: true)
        self.hidesBottomBarWhenPushed = false
//        if let dc = dateComponents
//        {
//            let day = DateComponents(
//                calendar: dc.calendar,
//                year: dc.year,
//                month: dc.month,
//                day: dc.day
//            )
//            
//            add(decoration: UICalendarView.Decoration.customView{
//                let label = UILabel()
//                label.text = "🏋️"
//                return label
//            }, on: day.date!)
//        }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        true
    }
    
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        
        let day = DateComponents(
            calendar: dateComponents.calendar,
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day
        )
        
        return selectDates[day.date]
    }
}
