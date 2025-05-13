import SwiftUI

struct GroupListView: View {
    @State private var groups: [ChatGroup] = []
    @State private var currentUserEmail: String = ""
    var body: some View {
        NavigationView {
            List {
                ForEach(groups.filter { $0.memberEmails.contains(currentUserEmail) }) { group in
                    NavigationLink(destination: GroupChatView(group: group)) {
                        VStack(alignment: .leading) {
                            Text(group.name)
                                .font(.headline)
                            Text("\(group.memberEmails.count) members")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Your Groups")
            .onAppear {
                loadGroups()
                currentUserEmail = UserDefaults.standard.string(forKey: "currentUser") ?? ""
            }
        }
    }
    
    func loadGroups() {
        if let data = UserDefaults.standard.data(forKey: "chatGroups"),
           let decoded = try? JSONDecoder().decode([ChatGroup].self, from: data) {
            self.groups = decoded
        }
    }
}
