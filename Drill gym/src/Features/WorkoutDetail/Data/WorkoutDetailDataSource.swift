import Foundation

protocol WorkoutDetailDataSource{
    func fetchWorkout(data: Date) throws -> DetailWorkout?
}
