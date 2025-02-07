import Foundation

enum WorkoutDetailEvents{
    case fetchWorkout(Date)
}

struct WorkoutDetailState{
    var error: Error?
    var workout: DetailWorkout?
}

final class WorkoutDetailStateContext: StateContext<WorkoutDetailState, WorkoutDetailEvents>{
    private let workoutDetailDataSource: WorkoutDetailDataSource
    
    init(workoutDetailDataSource: WorkoutDetailDataSource) {
        self.workoutDetailDataSource = workoutDetailDataSource
        super.init(state: WorkoutDetailState())
        
        on( { event in
            switch event {
            case .fetchWorkout(let date):
                self.fetchWorkout(date: date)
            case .none:
                logger.info("create event publisher")
            }
        })
    }
    
    private func fetchWorkout(date: Date) {
        do{
            guard let result = try workoutDetailDataSource.fetchWorkout(data: date) else {return}
            state.workout = result
            set(state: state)
        }catch{
            logger.error("createWorkout error: \(error)")
            state.error = error
        }
    }
}

