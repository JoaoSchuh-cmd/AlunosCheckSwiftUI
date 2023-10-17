//
//  ContentView.swift
//  AlunosCheck
//
//  Created by user241342 on 10/7/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath:\Student.name, ascending: true)],
        predicate: NSPredicate(format: "active == true"),
        animation: .default)
    private var students: FetchedResults<Student>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath:\Student.name, ascending: true)],
        animation: .default)
    private var allStudents: FetchedResults<Student>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(students) { student in
                    NavigationLink {
                        StudentDetailView(student: student)
                    } label: {
                        HStack {
                            Image(systemName: "person")
                            Text(student.name ?? "")
                        }
                        
                    }
                }
                .onDelete(perform: deleteStudent)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: reloadStudents) {
                        Label("Refresh Page", systemImage: "arrow.counterclockwise")
                    }
                }
                ToolbarItem {
                    NavigationLink(destination: CreateStudentView()) {
                        Label("Add Student", systemImage: "plus")
                    }
                }
            }
            Text("Select an student")
        }
        .onAppear(perform: reloadStudents)
    }
    
    private func reloadStudents() {
        for student in allStudents {
            student.active = true
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteStudent(offsets: IndexSet) {
        withAnimation {
            offsets.map { students[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
        
    }
}

struct StudentDetailView : View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var student : Student
    
    @State private var name : String
    @State private var cellphone : String
    
    init(student: Student) {
        self._student = State(initialValue: student)
        self._name = State(initialValue: student.name ?? "")
        self._cellphone = State(initialValue: student.cellphoneNumber ?? "")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stundent Detail")
                .font(.largeTitle)
                .bold()
            
            Spacer()
                .frame(height: 40)
            
            HStack {
                Text("Name:")
                TextField("", text: $name)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.secondary)
                            .frame(height: 40)
                    )
            }
            Spacer()
                .frame(height: 20)
            HStack {
                Text("Cellphone:")
                TextField("", text: $cellphone)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.secondary)
                            .frame(height: 40)
                    )
            }
            
            Spacer()
            
            HStack {
                Button(action: updateStudent) {
                    Text("Update Student Info")
                }
                Spacer()
                Button(action: inactivateStudent) {
                    Text("Inactivate user")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        
    }
    
    private func updateStudent() {
        student.name = name
        student.cellphoneNumber = cellphone
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func inactivateStudent() {
        student.active = false
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct CreateStudentView : View {
    @Environment(\.managedObjectContext) var viewContext
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name : String = ""
    @State private var cellphoneNumber : String = ""
    @State private var active : Bool = true
    
    var body : some View {
        VStack(alignment: .leading) {
            Text("Register New Student")
                .font(.largeTitle)
                .bold()
            
            Spacer()
                .frame(height: 40)
            
            VStack {
                TextField("Name", text: $name)
                    .font(.system(size: 20))
                    .padding(.bottom)
                
                TextField("Cellphone", text: $cellphoneNumber)
                    .font(.system(size: 20))
            }
            
            Spacer()
            
            HStack {
                Button(action: addStudent) {
                    Text("Salvar")
                }
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancelar")
                }
            }
        }
        .padding()
    }
    
    private func addStudent() {
        
        withAnimation {
            let newStudent = Student(context: viewContext)
            newStudent.name = name
            newStudent.cellphoneNumber = cellphoneNumber
            newStudent.active = true
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
