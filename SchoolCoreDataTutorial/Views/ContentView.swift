//
//  ContentView.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 29.05.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) private var teachers: FetchedResults<Teacher>
    @FetchRequest(sortDescriptors: []) private var students: FetchedResults<Student>
    @FetchRequest(sortDescriptors: []) private var classes: FetchedResults<SomeClass>
    
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Teachers
                Section {
                    List {
                        ForEach(teachers) { teacher in
                            NavigationLink(destination: TeacherDetailsScreen(teacher: teacher), label: {
                                Text(teacher.name ?? "Unknown name")
                            })
                        }
                        .onDelete(perform: deleteTeacher)
                    }
                    .environment(\.editMode, $editMode)
                } header: {
                    ZStack {
                        HStack {
                            Spacer()
                            NavigationLink(
                                destination: AddNewTeacher(),
                                label: {
                                    Image(systemName: "plus.app")
                                        .padding()
                                        .foregroundColor(Color.primary)
                                })
                        }
                        Text("All teachers")
                    }
                }
                
                // MARK: - Students
                Section {
                    List {
                        ForEach(students) { student in
                            NavigationLink(destination: StudentDetailsScreen(student: student), label: {
                                Text(student.name ?? "Unknown name")
                            })
                        }
                        .onDelete(perform: deleteStudent)
                    }
                    .environment(\.editMode, $editMode)
                } header: {
                    Text("All students")
                }
                
                // MARK: - Classes
                Section {
                    List {
                        ForEach(classes) { theClass in
                            NavigationLink(destination: ClassDetailsScreen(theClass: theClass), label: {
                                Text(theClass.name ?? "Unknown name")
                            })
                        }
                        .onDelete(perform: deleteClass)
                    }
                    .environment(\.editMode, $editMode)
                } header: {
                    ZStack {
                        HStack {
                            Spacer()
                            NavigationLink(destination: AddNewClass(moc: moc), label: {
                                Image(systemName: "plus.app")
                                    .padding(.trailing)
                                    .foregroundColor(.primary)
                            })
                        }
                        Text("All classes")
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button {
                        if editMode == .active {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                editMode = .inactive
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                editMode = .active
                            }
                        }
                    } label: {
                        Image(systemName: editMode == .active ? "checkmark" : "trash")
                            .padding()
                            .foregroundColor(Color.primary)
                    }
                })
            }
        }
    }
    
    // MARK: - Functions
    private func deleteTeacher(at offsets: IndexSet) {
        for offset in offsets {
            let teacher = teachers[offset]
            moc.delete(teacher)
        }
        try? moc.save()
    }
    
    private func deleteStudent(at offsets: IndexSet) {
        for offset in offsets {
            let student = students[offset]
            moc.delete(student)
        }
        try? moc.save()
    }
    
    private func deleteClass(at offsets: IndexSet) {
        for offset in offsets {
            let deletedClass = classes[offset]
            moc.delete(deletedClass)
        }
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
