struct CalendarState{
    var isLoading: Bool
    var workoutsDates: [CalendarWorkout]? //переписать на доменную модель
    var workouts: [Workout]? // переписать на доменную модель
    var error: Error?
    
    init(isLoading: Bool = false, workouts: [Workout]? = nil, error: Error? = nil, workoutsDates: [CalendarWorkout]? = nil) {
        self.isLoading = isLoading
        self.workouts = workouts
        self.error = error
    }
}
