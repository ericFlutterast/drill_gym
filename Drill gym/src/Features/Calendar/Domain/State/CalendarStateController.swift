import os

enum CalendarStateControllerEvents{
    case createWorkout(WorkoutModel)
    case fetchWorkouts
    case fetchCalendarWorkouts
}

final class CalendarStateController{
    let logger = Logger()
    private let state: CalendarState
    var calendarState: CalendarState {state}
    private let calendarDataSource: CalendarDataSource
    
    init(calendarDataSourse: CalendarDataSource) {
        self.state = CalendarState()
        self.calendarDataSource = calendarDataSourse
    }
    
    func addEvent(event: CalendarStateControllerEvents) {
        switch event {
        case .createWorkout(let workout):
            createWorkout(workout: workout)
        case .fetchWorkouts:
            fetchWorkouts()
        case .fetchCalendarWorkouts:
            fetchCalendarWorkouts()
        }
    }
    
    private func createWorkout(workout: WorkoutModel) {
        do{
            try calendarDataSource.createWorkout(workout: workout)
        }catch{
            logger.error("createWorkout error: \(error)")
            //Залогировать ошибку
            //добавить в состояние ошибку
        }
    }
    
    private func fetchWorkouts() {
        do{
            let result = try calendarDataSource.fetchWorkouts()
            state.workouts = result
        }catch{
            logger.error("fetchWorkouts: \(error)")
            //Залогировать ошибку
            //добавить в состояние ошибку
        }
    }
    
    private func fetchCalendarWorkouts() {
        do{
            let result = try calendarDataSource.fetchCalendarWorkouts()
            print(result)
        }catch{
            logger.error("fetchCalendarWorkouts: \(error)")
            //Залогировать ошибку
            //добавить в состояние ошибку
        }
    }
}

