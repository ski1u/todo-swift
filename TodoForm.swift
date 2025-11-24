import SwiftUI

struct TodoFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var data: Todos
    
    @Binding var todo: Todo?
    var isEditing: Bool { todo != nil }
    
    @State var editedTodo: Todo = Todo(title: "", desc: "")
    @State private var titleError: String? = nil
    @State private var descError: String? = nil
    
    @FocusState private var focusedField: Field?
    enum Field { case title, desc }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(hex: "#222").ignoresSafeArea()
                VStack(alignment: .leading) {
                    ZStack(alignment: .leading) {
                        if editedTodo.title.isEmpty {
                            Text("Task Title")
                                .foregroundColor(Color(hex: "#999"))
                                .bold()
                                .font(.title)
                        }
                        TextField("Task Title", text: $editedTodo.title)
                            .textFieldStyle(.plain)
                            .font(.title)
                            .foregroundColor(.white)
                            .bold()
                            .background(Color.clear)
                            .scrollContentBackground(.hidden)
                            .focused($focusedField, equals: .title)
                            .onChange(of: editedTodo.title) {
                                validateTitle()
                            }
                            .onSubmit {
                                if validateTitle() {
                                    focusedField = .desc
                                }
                            }
                    }
                    Divider().background(.white)
                    ZStack(alignment: .topLeading) {
                        if editedTodo.desc.isEmpty {
                            Text("Task Description")
                                .foregroundColor(Color(hex: "#999"))
                                .padding(.leading, 4)
                                .padding(.top, 8)
                        }
                        
                        TextEditor(text: $editedTodo.desc)
                            .frame(maxHeight: 200)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .focused($focusedField, equals: .desc)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            if !validateTitle() { return }
                            if isEditing {
                                saveChanges()
                            } else {
                                createTodo()
                            }
                        } label: {
                            Text(isEditing ? "Save" : "Create")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!isFormValid)
                        .controlSize(.regular)
                    }
                }
                .onAppear {
                    if let existing = todo {
                        editedTodo = existing
                    } else {
                        editedTodo = Todo(title: "", desc: "")
                    }
                }
                .padding()
            }
        }
    }
}

extension TodoFormView {
    @discardableResult
    func validateTitle() -> Bool {
        if editedTodo.title.trimmingCharacters(in: .whitespaces).isEmpty {
            titleError = "Title cannot be empty."
            return false
        }
        titleError = nil
        return true
    }
    
    func saveChanges() -> Void {
        guard isFormValid else { return }
        
        todo = editedTodo
        todo?.dateUpdated = .now
        dismiss()
    }
    
    func createTodo() -> Void {
        guard isFormValid else { return }
        
        withAnimation(.spring) {
            data.todos.insert(editedTodo, at: 0)
        }
    
        editedTodo = Todo(title: "", desc: "")
        dismiss()
    }

    var isFormValid: Bool {
        !editedTodo.title.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

#Preview {
    TodoFormView(todo: .constant(Todo(
        title: "Testing",
        desc: "This is a testing task",
        isComplete: false
    )))
}
