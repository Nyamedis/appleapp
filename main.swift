import SwiftUI

struct ContentView: View {
    @ObservedObject var taskManager = TaskManager()
    @State private var showingAddTaskView = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(taskManager.tasks) { task in
                        TaskRow(task: task)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Meine Aufgaben", displayMode: .large)
                .navigationBarItems(trailing: Button(action: {
                    showingAddTaskView = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                })
                .sheet(isPresented: $showingAddTaskView) {
                    AddTaskView(taskManager: taskManager)
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct TaskRow: View {
    var task: Task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted, color: .gray)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(dateToString(task.dueDate))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if task.isCompleted {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(task.isCompleted ? Color(.systemGray5) : Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
    }
    
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct AddTaskView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Aufgabeninfo")) {
                    TextField("Titel", text: $title)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    TextField("Beschreibung", text: $description)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    DatePicker("Fälligkeitsdatum", selection: $dueDate, displayedComponents: .date)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Neue Aufgabe", displayMode: .inline)
            .navigationBarItems(leading: Button("Abbrechen") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Speichern") {
                taskManager.addTask(title: title, description: description, dueDate: dueDate)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
