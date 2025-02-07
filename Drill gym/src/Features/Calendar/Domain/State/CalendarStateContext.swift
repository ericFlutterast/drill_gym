import os
import Combine

//Events для вызова различных методов
enum CalendarStateContextEvents{
    case createWorkout(WorkoutModel)
    case fetchWorkouts
    case fetchCalendarWorkouts
}

final class CalendarStateContext: StateContext<CalendarState, CalendarStateContextEvents>{
    private var calendarDataSource: CalendarDataSource

    init(calendarDataSourse: CalendarDataSource) {
        self.calendarDataSource = calendarDataSourse
        super.init(state: CalendarState())
        
        on { event in
            switch event {
            case .createWorkout(let workout):
                self.createWorkout(workout: workout)
            case .fetchWorkouts:
                self.fetchWorkouts()
            case .fetchCalendarWorkouts:
                self.fetchCalendarWorkouts()
            case .none:
                logger.info("create event publisher")
            }}
    }
    
    private func createWorkout(workout: WorkoutModel) {
        do{
            try calendarDataSource.createWorkout(workout: workout)
        }catch{
            logger.error("createWorkout error: \(error)")
            state.error = error
        }
    }
    
    private func fetchWorkouts() {
        do{
            let result = try calendarDataSource.fetchWorkouts()
            state.workouts = result
            set(state: state)
        }catch{
            logger.error("fetchWorkouts: \(error)")
            state.error = error
        }
    }
    
    private func fetchCalendarWorkouts() {
        do{
            let result = try calendarDataSource.fetchCalendarWorkouts()
            state.workoutsDates = result
            set(state: self.state)
        }catch{
            logger.error("fetchCalendarWorkouts: \(error)")
            state.error = error
        }
    }
}


