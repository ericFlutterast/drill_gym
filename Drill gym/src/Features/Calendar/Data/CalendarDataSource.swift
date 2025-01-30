import CoreData

protocol CalendarDataSource{
    func createWorkout(workout: WorkoutModel) throws
    func fetchWorkouts() throws -> [Workout]
    func fetchCalendarWorkouts() throws -> [CalendarWorkout]
}
