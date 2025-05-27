//
//  Task+CoreDataProperties.swift
//  Training
//
//  Created by kana.sugimoto on 2025/05/27.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String
    @NSManaged public var status: String
    @NSManaged public var content: String?
    @NSManaged public var expiredDate: Date?
    @NSManaged public var createdDate: Date
    @NSManaged public var priority: String?

}

extension Task : Identifiable {

}
