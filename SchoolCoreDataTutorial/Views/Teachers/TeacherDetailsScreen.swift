//
//  TeacherDetailsScreen.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 29.05.2023.
//

import SwiftUI
import CoreData

struct TeacherDetailsScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    
    let teacher: Teacher
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                // MARK: - Full name
                Text("Full name")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(teacher.name ?? "Unknown name")
                    .font(.title)
                    .padding(.bottom)
                
                // MARK: - Salary
                Text("Salary")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(teacher.salary ?? "Unknown amount")
                    .font(.title)
                    .padding(.bottom)
                
                // MARK: - Students
                Text("Students")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                ForEach(teacher.studentsArray) { student in
                    Text(student.unwrappedStudentsName)
                }
                
                NavigationLink(destination: AddTeachersStudent(teacher: teacher), label: {
                    Image(systemName: "plus.app")
                        .padding()
                        .foregroundColor(Color.primary)
                })
                
                // MARK: - Classes
                Text("Classes")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                ForEach(teacher.classesArray) { thisClass in
                    Text(thisClass.name ?? "Unknown name")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .foregroundColor(.primary)
            .navigationBarBackButtonHidden()
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
                    Button(action: deleteTeacher, label: {
                        Image(systemName: "trash")
                            .padding()
                            .foregroundColor(Color.primary)
                    })
                })
            }
        }
    }
    
    // MARK: - Functions
    private func deleteTeacher() {
        moc.delete(teacher)
        try? moc.save()
        dismiss()
    }
}

struct TeacherDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TeacherDetailsScreen(
            teacher: Teacher()
        )
    }
}
