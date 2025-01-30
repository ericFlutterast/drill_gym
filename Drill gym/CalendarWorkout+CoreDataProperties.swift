//
//  CalendarWorkout+CoreDataProperties.swift
//  Drill gym
//
//  Created by ericFlutter on 30.01.2025.
//
//

import Foundation
import CoreData


extension CalendarWorkout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalendarWorkout> {
        return NSFetchRequest<CalendarWorkout>(entityName: "CalendarWorkout")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var status: String?
    @NSManaged public var workout_id: UUID?
    @NSManaged public var calendar: NSSet?

}

// MARK: Generated accessors for calendar
extension CalendarWorkout {

    @objc(addCalendarObject:)
    @NSManaged public func addToCalendar(_ value: Workout)

    @objc(removeCalendarObject:)
    @NSManaged public func removeFromCalendar(_ value: Workout)

    @objc(addCalendar:)
    @NSManaged public func addToCalendar(_ values: NSSet)

    @objc(removeCalendar:)
    @NSManaged public func removeFromCalendar(_ values: NSSet)

}

extension CalendarWorkout : Identifiable {

}
