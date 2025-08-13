//
//  taskentity+coredataproperties.swift
//  PebblePath
//
//  Created by Yu-Shan Cheng on 8/12/25.
//

// TaskEntity+CoreDataProperties.swift
extension TaskEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var isCompleted: Bool
}
