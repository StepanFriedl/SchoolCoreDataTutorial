//
//  AddSchoolScreen.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 29.05.2023.
//

import SwiftUI
import CoreData

struct AddNewTeacher: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var teachersName: String = ""
    @State private var teachersSalary: String = ""
    
    // popup alert
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var alertAction: (() -> Void) = {}
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("bla bla bla", text: $teachersName)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text("Full name")
                }
                Section {
                    TextField("bla bla", text: $teachersSalary)
                        .autocorrectionDisabled()
                        .keyboardType(.numberPad)
                } header: {
                    Text("Salary")
                }
            }
            .foregroundColor(Color.primary)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrowshape.backward.fill")
                        .padding()
                        .foregroundColor(Color.primary)
                }
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button (action: saveTeacher, label: {
                    Image(systemName: "checkmark")
                        .padding()
                        .foregroundColor(Color.primary)
                })
            })
        }
        .navigationBarBackButtonHidden()
        // .setToolbarBackground()
        .navigationTitle("Add school")
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Functions
    private func saveTeacher() {
        let newTeacher = Teacher(context: moc)
        newTeacher.id = UUID()
        newTeacher.name = teachersName
        newTeacher.salary = teachersSalary
        try? moc.save()
        alertTitle = "Success"
        alertMessage = "New teacher has been saved successfully!"
        alertAction = {
            dismiss()
        }
        showAlert = true
    }
    
}

struct AddNewTeacher_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTeacher()
    }
}
