//
//  File.swift
//  Drill gym
//
//  Created by ericFlutter on 06.02.2025.
//

import Foundation

class Dependencies{
    static let shared = Dependencies()
    
    private let calendarDataSourceDependency: CalendarDataSource
    private let workoutDetailDataSourceDependency: WorkoutDetailDataSource
    private let calendarStateContextDependency: StateContext<CalendarState, CalendarStateContextEvents>
    private let workoutDetailStateContextDependency: StateContext<WorkoutDetailState, WorkoutDetailEvents>
    
    var calendarDataSource: CalendarDataSource{calendarDataSourceDependency}
    var calendarStateContext: StateContext<CalendarState, CalendarStateContextEvents>{calendarStateContextDependency}
    var workoutDetailDataSource: WorkoutDetailDataSource{workoutDetailDataSourceDependency}
    var workoutDetailStateContext: StateContext<WorkoutDetailState, WorkoutDetailEvents>{workoutDetailStateContextDependency}
    
    private init() {
        self.calendarDataSourceDependency = CalendarDataSourceImpl(dataManager: DataManger.shared)
        self.workoutDetailDataSourceDependency = WorkoutDetailDataSourceImpl(dataManager: DataManger.shared)
        self.calendarStateContextDependency = CalendarStateContext(calendarDataSourse: self.calendarDataSourceDependency)
        self.workoutDetailStateContextDependency = WorkoutDetailStateContext(workoutDetailDataSource: self.workoutDetailDataSourceDependency)
    }
}
