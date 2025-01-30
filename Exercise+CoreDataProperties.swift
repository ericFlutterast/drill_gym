//
//  Exercise+CoreDataProperties.swift
//  Drill gym
//
//  Created by ericFlutter on 31.01.2025.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var repeats: Int32
    @NSManaged public var approashes: Int32
    @NSManaged public var progressPercent: Float
    @NSManaged public var weight: Float
    @NSManaged public var workout: Workout?

}

extension Exercise : Identifiable {

}
