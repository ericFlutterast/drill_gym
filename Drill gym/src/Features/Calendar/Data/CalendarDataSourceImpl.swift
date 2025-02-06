import Foundation

final class CalendarDataSourceImpl: CalendarDataSource{
    private let dataManager: DataManger
    
    init(dataManager: DataManger) {
        self.dataManager = dataManager
    }
    
    func createWorkout(workout workoutModel: WorkoutModel) throws {
        let context = dataManager.persistentContainer.viewContext
        
        let calendarWorkout = CalendarWorkout(context: context)
        calendarWorkout.date = workoutModel.date
        

        let workout = Workout(context: context)
        workout.name = workoutModel.name
        workout.progressPercent = 0
        workout.calendarWorkout = calendarWorkout
        
        for item in workoutModel.exercises {
            let exercise = Exercise(context: context)
            exercise.name = item.exerciseName
            exercise.approashes = Int32(item.approaches)
            exercise.repeats = Int32(item.repeats)
            exercise.weight = item.weight ?? 0.0
            workout.addToExercises(exercise)
        }
        dataManager.saveContext()
    }
    
    func fetchWorkouts() throws -> [Workout] {
        let context = dataManager.persistentContainer.viewContext
        let result = try context.fetch(Workout.fetchRequest())
        return result
    }
    
    func fetchCalendarWorkouts() throws -> [CalendarWorkout] {
        let context = dataManager.persistentContainer.viewContext
        let result = try context.fetch(CalendarWorkout.fetchRequest())
        return result
    }
}
