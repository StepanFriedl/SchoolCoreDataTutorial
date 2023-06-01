//
//  SomeClass+CoreDataProperties.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 31.05.2023.
//
//

import Foundation
import CoreData


extension SomeClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SomeClass> {
        return NSFetchRequest<SomeClass>(entityName: "SomeClass")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var size: Int16
    @NSManaged public var students: NSSet?
    @NSManaged public var teacher: Teacher?
    
    public var studentsArray: [Student] {
        let studentSet = students as? Set<Student> ?? []
        
        return studentSet.sorted {
            $0.unwrappedStudentsName < $1.unwrappedStudentsName
        }
    }
}

// MARK: Generated accessors for students
extension SomeClass {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

extension SomeClass : Identifiable {

}
