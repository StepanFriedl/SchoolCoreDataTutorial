//
//  Student+CoreDataProperties.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 31.05.2023.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var age: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var classes: NSSet?
    @NSManaged public var teacher: Teacher?

    public var unwrappedStudentsName: String {
        name ?? "Unknown name"
    }
    
    public var classesArray: [SomeClass] {
        let classesSet = classes as? Set<SomeClass> ?? []
        
        return classesSet.sorted {
            $0.name ?? "A" < $1.name ?? "B"
        }
    }
}

// MARK: Generated accessors for classes
extension Student {

    @objc(addClassesObject:)
    @NSManaged public func addToClasses(_ value: SomeClass)

    @objc(removeClassesObject:)
    @NSManaged public func removeFromClasses(_ value: SomeClass)

    @objc(addClasses:)
    @NSManaged public func addToClasses(_ values: NSSet)

    @objc(removeClasses:)
    @NSManaged public func removeFromClasses(_ values: NSSet)

}

extension Student : Identifiable {

}
