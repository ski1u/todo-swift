import SwiftUI

@main
struct TodoApp: App {
    @StateObject var data = Todos()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(data)
        }
    }
}
