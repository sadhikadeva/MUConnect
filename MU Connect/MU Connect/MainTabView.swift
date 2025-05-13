import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                    .tabItem {
                        Label("Feed", systemImage: "house")
                    }
                

            ConnectView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Connect")
                }

            NewPostView()
                .tabItem {
                    Image(systemName: "plus.app.fill")
                    Text("Add Post")
                }

            ChatsView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chats")
                }
            

            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
