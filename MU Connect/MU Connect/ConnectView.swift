import SwiftUI

struct ConnectView: View {
    @State private var users: [String: [String: String]] = [:]
    @State private var currentUser: String = UserDefaults.standard.string(forKey: "currentUser") ?? ""
    @State private var followingList: [String] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(users.filter { $0.key != currentUser }, id: \.key) { email, data in
                    VStack(alignment: .leading) {
                        Text(data["name"] ?? "Unknown")
                            .font(.headline)
                        Text(data["batch"] ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(data["bio"] ?? "")
                            .font(.body)

                        Button(action: {
                            toggleFollow(email)
                        }) {
                            Text(followingList.contains(email) ? "Following" : "Follow")
                                .padding(6)
                                .frame(maxWidth: .infinity)
                                .background(followingList.contains(email) ? Color.green : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Connect")
        }
        .onAppear(perform: loadUsers)
    }

    func loadUsers() {
        users = UserDefaults.standard.dictionary(forKey: "users") as? [String: [String: String]] ?? [:]

        let allFollowing = UserDefaults.standard.dictionary(forKey: "followingList") as? [String: [String]] ?? [:]
        followingList = allFollowing[currentUser] ?? []
    }

    func toggleFollow(_ otherUser: String) {
        var allFollowing = UserDefaults.standard.dictionary(forKey: "followingList") as? [String: [String]] ?? [:]

        var currentFollowing = allFollowing[currentUser] ?? []

        if let index = currentFollowing.firstIndex(of: otherUser) {
            currentFollowing.remove(at: index)
        } else {
            currentFollowing.append(otherUser)
        }

        allFollowing[currentUser] = currentFollowing
        UserDefaults.standard.set(allFollowing, forKey: "followingList")
        followingList = currentFollowing
    }
}

#Preview {
    ConnectView()
}
