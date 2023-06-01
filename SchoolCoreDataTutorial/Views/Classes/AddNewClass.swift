//
//  AddNewClass.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 30.05.2023.
//

import SwiftUI
import CoreData
import Combine

struct AddNewClass: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) private var students: FetchedResults<Student>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) private var teachers: FetchedResults<Teacher>
    
    @State private var className: String = ""
    @State private var classSize: String = ""
    @State private var classStudents: [Student] = []
    @State var selectedTeacher: Teacher
    
    init(moc: NSManagedObjectContext) {
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
            Form {
                // MARK: - Class name
                Section {
                    TextField("Class name", text: $className)
                        .autocorrectionDisabled()
                } header: {
                    Text("Class name")
                }
                
                // MARK: - Class size
                Section {
                    TextField("Class size", text: $classSize)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Class size")
                }
                
                // MARK: - Students
                Section {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(students, id: \.self) { student in
                                Button {
                                    if classStudents.contains(student) {
                                        for index in 0..<classStudents.count {
                                            if classStudents[index].id == student.id {
                                                classStudents.remove(at: index)
                                            }
                                        }
                                    } else {
                                        classStudents.append(student)
                                    }
                                } label: {
                                    Text(student.name ?? "Unknown name")
                                        .padding(8)
                                }
                                .foregroundColor(classStudents.contains(student) ? Color.black : Color.primary )
                                .background(classStudents.contains(student) ? Color.gray : Color(.secondarySystemBackground))
                                .cornerRadius(8)
                            }
                        }
                    }
                } header: {
                    Text("Students")
                }
                
                // MARK: - Teachers
                Section {
                    Picker("", selection: $selectedTeacher) {
                        ForEach(teachers, id:\.self) { teacher in
                            Text(teacher.name ?? "Unknown name").tag(teacher)
                        }
                    }
                } header: {
                    Text("Teacher")
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrowshape.backward.fill")
                        .padding()
                        .foregroundColor(.primary)
                })
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: addClass, label: {
                    Image(systemName: "checkmark")
                        .padding()
                        .foregroundColor(.primary)
                })
            })
        }
        .navigationBarBackButtonHidden()
        .onReceive(Just(classSize)) { newValue in
            let filtered = newValue.filter {
                "0123456789".contains($0)
            }
            if filtered != newValue {
                self.classSize = filtered
            }
        }
    }
    
    // MARK: - Functions
    private func addClass() {
        let newClass = SomeClass(context: moc)
        newClass.id = UUID()
        newClass.name = className
        newClass.size = Int16(classSize) ?? 0
        /*
        let uniqeStudents = Set(classStudents)
        for student in uniqeStudents {
            newClass.addToStudents(student)
        }
         */
        for student in classStudents {
            newClass.addToStudents(student)
        }
        // newClass.students = classStudents
        newClass.teacher = selectedTeacher
        try? moc.save()
        dismiss()
    }
}
/*
struct AddNewClass_Previews: PreviewProvider {
    static var previews: some View {
        AddNewClass()
    }
}
*/
