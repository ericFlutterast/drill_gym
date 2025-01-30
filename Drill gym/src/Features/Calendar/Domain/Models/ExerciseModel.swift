import Foundation

struct ExerciseModel: Identifiable{
    var id: UUID
    let exerciseName: String
    let approaches: Int
    let repeats: Int
    let weight: Int?
}
