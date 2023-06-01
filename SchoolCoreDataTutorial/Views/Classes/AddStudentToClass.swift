//
//  AddStudentToClass.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 01.06.2023.
//

import SwiftUI
import CoreData

struct AddStudentToClass: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) private var teachers: FetchedResults<Teacher>
    
    let theClass: SomeClass
    
    @State private var studentsName: String = ""
    @State private var studentsAge: String = ""
    @State var selectedTeacher: Teacher
    
    // popup alert
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var alertAction: (() -> Void) = {}
    
    init(theClass: SomeClass, moc: NSManagedObjectContext) {
        self.theClass = theClass
        
        // create the fetch request
        let fetchRequest: NSFetchRequest<Teacher> = Teacher.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Teacher.name, ascending: true)]
        fetchRequest.predicate = NSPredicate(value: true)
        
        // perform the fetch request and store the fetched results
        self._teachers = FetchRequest(fetchRequest: fetchRequest)
        
        // fill the preselected selection based on the fetched results
        do {
            let firstTeacher = try moc.fetch(fetchRequest)
            if firstTeacher.isEmpty {
            // if there are no data, create selection and delete it, so there are no options in the picker
                self._selectedTeacher = State(initialValue: Teacher(context: moc))
                moc.delete(selectedTeacher)
            } else {
            // else preselect first option if there are andy data fetched
                self._selectedTeacher = State(initialValue: firstTeacher[0])
            }
        } catch {
        // fetch() is throwing function, so do-catch block should be used to catch errors (if any)
            fatalError("Uh oh")
        }
    }
    
    var body: some View {
        VStack {
            Form {
                // MARK: - Full name
                Section {
                    TextField("Bla bla bla", text: $studentsName)
                        .autocorrectionDisabled()
                } header: {
                    Text("Full name")
                }
                
                // MARK: - Age
                Section {
                    TextField("Blah", text: $studentsAge)
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                } header: {
                    Text("Age")
                }
                
                // MARK: - Teachers selection
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
            .foregroundColor(.primary)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Add a new student")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrowshape.backward.fill")
                        .padding()
                        .foregroundColor(.primary)
                }
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: addStudent, label: {
                    Image(systemName: "checkmark")
                        .padding()
                        .foregroundColor(.primary)
                })
            })
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("ok") {
                alertAction()
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Functions
    private func addStudent() {
        let newStudent = Student(context: moc)
        newStudent.id = UUID()
        newStudent.name = studentsName
        newStudent.age = Int16(studentsAge) ?? 0
        newStudent.teacher = selectedTeacher
        newStudent.addToClasses(theClass)
        try? moc.save()
        alertTitle = "Success"
        alertMessage = "New student has been saved successfully!"
        alertAction = {
            dismiss()
        }
        showAlert = true
    }
}
/*
struct AddStudentToClass_Previews: PreviewProvider {
    static var previews: some View {
        AddStudentToClass(
            theClass: SomeClass(),
            moc:
        )
    }
}
*/
