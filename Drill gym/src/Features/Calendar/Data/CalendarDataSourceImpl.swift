import Foundation

final class CalendarDataSourceImpl: CalendarDataSource{
    private let dataManager: DataManger
    
    init(dataManager: DataManger) {
        self.dataManager = dataManager
    }
    
    func createWorkout(workout workoutModel: WorkoutModel) throws {
        let context = dataManager.persistentContainer.viewContext
        let workout = Workout(context: context)
        workout.name = workoutModel.name
        workout.progressPercent = 0
        workout.exercises = workoutModel.exercises.map {exerciseModel in
            let exercise = Exercise(context: context)
            exercise.name = exerciseModel.exerciseName
            exercise.approashes = Int32(exerciseModel.approaches)
            exercise.repeats = Int32(exerciseModel.repeats)
            exercise.weight = exerciseModel.weight ?? 0.0
            return exercise
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
