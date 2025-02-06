import Combine

class StateContext<State, Event>{
    var state: State
    
    private let stateSubject: CurrentValueSubject<State, Never>
    private let evenSubject: CurrentValueSubject<Event?, Never>
    private var eventCancellable: AnyCancellable?
    
    var publisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    init(state: State) {
        self.state = state
        stateSubject = CurrentValueSubject<State, Never>(state)
        evenSubject = CurrentValueSubject<Event?, Never>(nil)
    }
    
    deinit{
        eventCancellable?.cancel()
    }
    
    
    func on(_ handler: @escaping (_ event: Event?) -> Void) {
        self.eventCancellable = evenSubject.eraseToAnyPublisher().sink(receiveValue: handler)
    }
    
    func add(event: Event) {
        evenSubject.send(event)
    }
    
    func set(state: State){
        stateSubject.send(state)
        self.state = state
    }
}
