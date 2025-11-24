import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data: Todos
    
    @State private var isCreating: Bool = false
    @State private var newTodo: Todo? = nil
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(hex: "#333").ignoresSafeArea()
                VStack {
                    if data.todos.isEmpty {
                        Text("Seems like there's no tasks here..  try adding one!")
                            .padding(.top, 24)
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                    } else {
                        List {
                            ForEach($data.todos) { $todo in
                                TodoCardView(todo: $todo, onDelete: {
                                    if let index = data.todos.firstIndex(of: todo) {
                                        withAnimation(.spring) {
                                            data.todos.remove(at: index)
                                        }
                                    }
                                })
                                .transition(.move(edge: .top).combined(with: .opacity))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(.init())
                                .padding(.vertical, 8)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .animation(.spring, value: data.todos)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            isCreating = true
                        } label: {
                            Text("New")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)
                    }
                }
                .sheet(isPresented: $isCreating) {
                    TodoFormView(todo: $newTodo)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Todos())
}
