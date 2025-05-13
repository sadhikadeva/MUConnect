
import SwiftUI

struct ConnectView: View {
    @State private var users: [MUUser] = []
    @State private var currentUserEmail: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(users.filter { $0.email != currentUserEmail }) { user in
                    NavigationLink(destination: UserProfileView(user: user)) {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Connect")
            .onAppear {
                loadUsers()
            }
        }
    }

    func loadUsers() {
        if let saved = UserDefaults.standard.data(forKey: "allUsers"),
           let decoded = try? JSONDecoder().decode([MUUser].self, from: saved) {
            self.users = decoded
        }

        self.currentUserEmail = UserDefaults.standard.string(forKey: "currentUser") ?? ""
    }
}
