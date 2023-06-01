//
//  ChangeTeacherScreen.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 30.05.2023.
//

import SwiftUI
import CoreData

struct ChangeTeacherScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: []) private var teachers: FetchedResults<Teacher>
    
    @State var selectedTeacher: Teacher
    
    let student: Student
    
    init(moc: NSManagedObjectContext, student: Student) {
        self.student = student
        let fetchRequest: NSFetchRequest<Teacher> = Teacher.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Teacher.name, ascending: true)]
        fetchRequest.predicate = NSPredicate(value: true)
        
        self._teachers = FetchRequest(fetchRequest: fetchRequest)
        
        do {
            let firstTeacher = try moc.fetch(fetchRequest)
            if firstTeacher.isEmpty {
                self._selectedTeacher = State(initialValue: Teacher(context: moc))
                moc.delete(selectedTeacher)
            } else {
                self._selectedTeacher = State(initialValue: firstTeacher[0])
            }
        } catch {
            fatalError("Uh oh")
        }
    }
    
    var body: some View {
        VStack {
            Text("Select new teacher")
            
            Picker(selection: $selectedTeacher, label: Text("AA")) {
                ForEach(teachers, id:\.self) { teacher in
                    Text(teacher.name ?? "Unknown name").tag(teacher.self)
                }
            }
            
            Button(action: saveTeacher, label: {
                Text("Save")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.horizontal)
            })
            .background(Color(.systemBlue))
            .cornerRadius(8)
        }
    }
    // MARK: - Functions
    private func saveTeacher() {
        student.teacher = selectedTeacher
        try? moc.save()
    }
}
