import Foundation

final class WorkoutDetailDataSourceImpl: WorkoutDetailDataSource{
    private let dataManager: DataManger
    
    init(dataManager: DataManger) {
        self.dataManager = dataManager
    }
    
    func fetchWorkout(data: Date) throws -> DetailWorkout? {
        let context = dataManager.persistentContainer.viewContext
        let request = CalendarWorkout.fetchRequest()
        let predicate = NSPredicate(format: "date == %@", data as NSDate)
        request.predicate = predicate
        let result = try! context.fetch(request)
        let calendarWorkout = result.first?.calendarWorkout
        let newExercises = calendarWorkout?.exercises as? Set<Exercise> ?? []
        
        return DetailWorkout(
            name: calendarWorkout?.name ?? "",
            exercisesDesc: newExercises.map {"·  \($0.name ?? ""): \($0.approashes) X \($0.repeats)"},
            percentProgress: calendarWorkout?.progressPercent ?? 0.0)
    }
}
