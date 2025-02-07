//
//  CalendarWorkout+CoreDataProperties.swift
//  Drill gym
//
//  Created by ericFlutter on 06.02.2025.
//
//

import Foundation
import CoreData


extension CalendarWorkout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalendarWorkout> {
        return NSFetchRequest<CalendarWorkout>(entityName: "CalendarWorkout")
    }

    @NSManaged public var date: Date?
    @NSManaged public var status: String?
    @NSManaged public var calendarWorkout: Workout?

}

extension CalendarWorkout : Identifiable {

}
