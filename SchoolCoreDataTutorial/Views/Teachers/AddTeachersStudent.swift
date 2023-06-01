//
//  AddNewStudent.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 29.05.2023.
//

import SwiftUI
import CoreData

struct AddTeachersStudent: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss
    
    let teacher: Teacher
    
    @State private var studentsName: String = ""
    @State private var studentsAge: String = ""
    
    // popup alert
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var alertAction: (() -> Void) = {}
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Bla bla bla", text: $studentsName)
                        .autocorrectionDisabled()
                } header: {
                    Text("Full name")
                }
                Section {
                    TextField("Blah", text: $studentsAge)
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                } header: {
                    Text("Age")
                }
            }
            .foregroundColor(Color.primary)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Add new student")
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
        newStudent.teacher = teacher
        try? moc.save()
        alertTitle = "Success"
        alertMessage = "New teacher has been saved successfully!"
        alertAction = {
            dismiss()
        }
        showAlert = true
    }
}

struct AddNewStudent_Previews: PreviewProvider {
    static var previews: some View {
        AddTeachersStudent(
            teacher: Teacher()
        )
    }
}
