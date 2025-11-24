import SwiftUI
internal import Combine

class Todos : ObservableObject {
    @Published var todos = [
        Todo(title: "Testing Task.", desc: "This is a testing task!"),
    ]
}

struct Todo : Identifiable, Equatable {
    var title: String
    var desc: String
    var isComplete: Bool = false
    
    var dateCreated: Date = .now
    var dateUpdated: Date = .now
    
    var id = UUID()
}
