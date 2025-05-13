import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "list.bullet")
                }

            NewPostView()
                .tabItem {
                    Label("New Post", systemImage: "square.and.pencil")
                }
        }
        
    }
}

