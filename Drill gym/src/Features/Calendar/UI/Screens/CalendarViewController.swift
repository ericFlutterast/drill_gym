import UIKit
import Combine

class CalendarViewController: UIViewController{
    private var datesWithWorkouts = [Date?: UICalendarView.Decoration]()
    
    private var calendarStateContext = CalendarStateContext(calendarDataSourse: CalendarDataSourceImpl(dataManager: DataManger.shared))
    
    private var calendarContextCancellable: AnyCancellable?
    
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
    
    deinit{
        calendarContextCancellable?.cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarStateContext.add(event: .fetchCalendarWorkouts)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        configurateController()
        calendarContextCancellable = calendarStateContext.publisher.sink { state in
            self.decorateCalendar(from: state.workoutsDates ?? [])
        }
    }
    
    @objc private func addWorkoutHandler() {
        print("tapped")
    }
    
    private func decorateCalendar(from dates: [CalendarWorkout]) {
        var dateComponents: [DateComponents] = []
        for item in dates{
            let dc = Calendar.current.dateComponents([.calendar, .year, .month, .day], from: item.date ?? Date())
            
            datesWithWorkouts[dc.date] = UICalendarView.Decoration.customView{
                let label = UILabel()
                label.text = "🏋️"
                return label
            }
            dateComponents.append(dc)
        }
        
        calendarView.reloadDecorations(
            forDateComponents: dateComponents,
            animated: true
        )
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
}

extension CalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let navController = navigationController
        else{
            return
        }
        
        self.hidesBottomBarWhenPushed = true
        if datesWithWorkouts.keys.contains(dateComponents?.date) {
            let workoutDetail = WorkoutDetailViewController(workoutDetailStateContext: Dependencies.shared.workoutDetailStateContext)
            workoutDetail.selectedDate = dateComponents?.date
            navController.pushViewController(workoutDetail, animated: true)
        }else{
            let addWorkoutOnCalendarWorkout = AddWorkoutOnCalendarViewController(calendarStateContext: Dependencies.shared.calendarStateContext)
            guard let dc = dateComponents
            else {return}
            addWorkoutOnCalendarWorkout.selectedDate = dc
            navController.pushViewController(addWorkoutOnCalendarWorkout, animated: true)
        }
        self.hidesBottomBarWhenPushed = false
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
        
        return datesWithWorkouts[day.date]
    }
}
