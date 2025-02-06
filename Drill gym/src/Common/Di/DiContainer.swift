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
    private let calendarStateContextDependency: StateContext<CalendarState, CalendarStateContextEvents>
    
    var calendarDataSource: CalendarDataSource{calendarDataSourceDependency}
    var calendarStateContext: StateContext<CalendarState, CalendarStateContextEvents>{calendarStateContextDependency}
    
    private init() {
        self.calendarDataSourceDependency = CalendarDataSourceImpl(dataManager: DataManger.shared)
        self.calendarStateContextDependency = CalendarStateContext(calendarDataSourse: self.calendarDataSourceDependency)
    }
}
