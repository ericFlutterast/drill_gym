//
//  CalendarWorkout+CoreDataProperties.swift
//  Drill gym
//
//  Created by ericFlutter on 31.01.2025.
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
    @NSManaged public var calendarWorkout: NSSet?

}

// MARK: Generated accessors for calendarWorkout
extension CalendarWorkout {

    @objc(addCalendarWorkoutObject:)
    @NSManaged public func addToCalendarWorkout(_ value: Workout)

    @objc(removeCalendarWorkoutObject:)
    @NSManaged public func removeFromCalendarWorkout(_ value: Workout)

    @objc(addCalendarWorkout:)
    @NSManaged public func addToCalendarWorkout(_ values: NSSet)

    @objc(removeCalendarWorkout:)
    @NSManaged public func removeFromCalendarWorkout(_ values: NSSet)

}

extension CalendarWorkout : Identifiable {

}
