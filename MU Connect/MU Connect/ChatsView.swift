import SwiftUI

struct ChatsView: View {
    @State private var users: [String: [String: String]] = [:]
    @State private var followingList: [String] = []
    @State private var currentUser: String = UserDefaults.standard.string(forKey: "currentUser") ?? ""

    var body: some View {
        NavigationView {
            List {
                ForEach(followingList, id: \.self) { followedEmail in
                    if let userData = users[followedEmail] {
                        NavigationLink(destination: ChatDetailView(chatWith: followedEmail, currentUser: currentUser, name: userData["name"] ?? "Unknown")) {
                            VStack(alignment: .leading) {
                                Text(userData["name"] ?? "Unknown")
                                    .font(.headline)
                                Text(userData["batch"] ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Chats")
        }
        .onAppear(perform: loadData)
    }

    func loadData() {
        users = UserDefaults.standard.dictionary(forKey: "users") as? [String: [String: String]] ?? [:]
        let allFollowing = UserDefaults.standard.dictionary(forKey: "followingList") as? [String: [String]] ?? [:]
        followingList = allFollowing[currentUser] ?? []
    }
}

#Preview {
    ChatsView()
}
