//
//  StudentDetailsScreen.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 29.05.2023.
//

import SwiftUI
import CoreData

struct StudentDetailsScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: []) private var teachers: FetchedResults<Teacher>
    
    let student: Student
    let teacher: Teacher
    
    init (student: Student) {
        self.student = student
        self.teacher = student.teacher ?? Teacher()
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                // MARK: - Name
                Text("Full name")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(student.unwrappedStudentsName)
                    .font(.title)
                    .padding(.bottom)
                
                // MARK: - Age
                Text("Age")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(String(student.age))
                    .font(.title)
                
                // MARK: - Teacher
                HStack {
                    Text("Teacher")
                        .font(.title3)
                        .foregroundColor(.secondary)
                
                    Spacer()
                    
                    NavigationLink(destination: ChangeTeacherScreen(
                        moc: moc,
                        student: student
                    ), label: {
                        Image(systemName: "wrench.adjustable")
                            .padding(.trailing)
                    })
                }
                if let teachersName = student.teacher?.name {
                    Text(teachersName)
                }
                // Text(teacher.name ?? "Unknown name")
                
                // MARK: - Classes
                Text("Classes")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                ForEach(student.classesArray) { thisClass in
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
                    Button(action: deleteStudent, label: {
                        Image(systemName: "trash")
                            .padding()
                            .foregroundColor(Color.primary)
                    })
                })
            }
        }
    }
    
    // MARK: - Functions
    private func deleteStudent() {
        moc.delete(student)
        try? moc.save()
        dismiss()
    }
}

struct StudentDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        StudentDetailsScreen(
            student: Student()
        )
    }
}
