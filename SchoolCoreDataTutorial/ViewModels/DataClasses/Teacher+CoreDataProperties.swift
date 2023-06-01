//
//  Teacher+CoreDataProperties.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 31.05.2023.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var salary: String?
    @NSManaged public var classes: NSSet?
    @NSManaged public var students: NSSet?
    
    public var studentsArray: [Student] {
        let studentsSet = students as? Set<Student> ?? []
        
        return studentsSet.sorted {
            $0.unwrappedStudentsName < $1.unwrappedStudentsName
        }
    }
    
    public var classesArray: [SomeClass] {
        let classesSet = classes as? Set<SomeClass> ?? []
        
        return classesSet.sorted {
            $0.name ?? "A" < $1.name ?? "B"
        }
    }
}

// MARK: Generated accessors for classes
extension Teacher {

    @objc(addClassesObject:)
    @NSManaged public func addToClasses(_ value: SomeClass)

    @objc(removeClassesObject:)
    @NSManaged public func removeFromClasses(_ value: SomeClass)

    @objc(addClasses:)
    @NSManaged public func addToClasses(_ values: NSSet)

    @objc(removeClasses:)
    @NSManaged public func removeFromClasses(_ values: NSSet)

}

// MARK: Generated accessors for students
extension Teacher {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

extension Teacher : Identifiable {

}
