//
//  ClassDetailsScreen.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 01.06.2023.
//

import SwiftUI

struct ClassDetailsScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: []) private var students: FetchedResults<Student>
    
    let theClass: SomeClass
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                // MARK: - Name
                Text("Class name")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(theClass.name ?? "Unknown name")
                    .font(.title)
                    .padding(.bottom)
                
                // MARK: - Size
                Text("Size")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(String(theClass.size))
                    .font(.title)
                
                // MARK: - Students
                Text("Students")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                ForEach(theClass.studentsArray) { student in
                    Text(student.name ?? "Unknown name")
                }
                
                NavigationLink(destination: AddStudentToClass(theClass: theClass, moc: moc), label: {
                    Image(systemName: "plus.app")
                        .padding()
                        .foregroundColor(.primary)
                })
                
                // MARK: - Teacher
                Text("Teacher")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(theClass.teacher?.name ?? "Unknown name")
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
                            .foregroundColor(.primary)
                    }
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: deleteClass, label: {
                        Image(systemName: "trash")
                            .padding()
                            .foregroundColor(.primary)
                    })
                })
            }
        }
    }
    
    // MARK: - Functions
    private func deleteClass() {
        moc.delete(theClass)
        try? moc.save()
        dismiss()
    }
}

struct ClassDetailsScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        ClassDetailsScreen(
            theClass: SomeClass()
        )
    }
}
