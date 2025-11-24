
import SwiftUI

struct TodoCardView: View {
    @Binding var todo: Todo
    var onDelete: () -> Void = {}
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack { // Checkbox & Title
                    Button {
                        withAnimation {
                            todo.isComplete.toggle()
                            todo.dateUpdated = .now
                        }
                    } label: {
                        Image(systemName: todo.isComplete ? "checkmark.square.fill" : "square")
                            .foregroundColor(.white)
                    }
                    Text(todo.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .strikethrough(todo.isComplete)
                }
                Divider()
                    .background(.white)
                    .padding(.bottom, 8)
                Text(todo.desc)
                    .font(.callout)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "#444"))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.3), radius: 12, y: 6)
        }
        .opacity(todo.isComplete ? 0.6 : 1.0)
        
        .contextMenu {
            Button {
                isEditing = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button {
                withAnimation {
                    todo.isComplete.toggle()
                    todo.dateUpdated = .now
                }
            } label: {
                Label("Complete", systemImage: "checkmark")
            }
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                withAnimation {
                    todo.isComplete.toggle()
                    todo.dateUpdated = .now
                }
            } label: {
                Label("Complete", systemImage: "checkmark")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $isEditing) {
            TodoFormView(todo: Binding(
                get: { todo },
                set: { updated in
                    if let updated {
                        todo = updated
                    }
                }
            ))
        }
    }
}

#Preview {
    List {
        TodoCardView(todo: .constant(
            Todo(
                title: "Testing",
                desc: "This is a testing task",
                isComplete: false
            )
        ))
        .transition(.move(edge: .top).combined(with: .opacity))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
}
