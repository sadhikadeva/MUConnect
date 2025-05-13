import SwiftUI

struct CreateGroupView: View {
    @State private var groupName: String = ""
    @State private var selectedMembers: Set<String> = []
    @State private var allUsers: [MUUser] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Name")) {
                    TextField("Enter group name", text: $groupName)
                }
                
                Section(header: Text("Select Members")) {
                    List(allUsers, id: \.email) { user in
                        MultipleSelectionRow(title: user.name, isSelected: selectedMembers.contains(user.email)) {
                            if selectedMembers.contains(user.email) {
                                selectedMembers.remove(user.email)
                            } else {
                                selectedMembers.insert(user.email)
                            }
                        }
                    }
                }
                
                Button("Create Group") {
                    saveGroup()
                    dismiss()
                }
                .disabled(groupName.isEmpty || selectedMembers.isEmpty)
            }
            .navigationTitle("New Group")
            .onAppear {
                loadUsers()
            }
        }
    }
    
    func loadUsers() {
        if let data = UserDefaults.standard.data(forKey: "allUsers"),
           let users = try? JSONDecoder().decode([MUUser].self, from: data) {
            allUsers = users
        }
    }
    
    func saveGroup() {
        let newGroup = ChatGroup(name: groupName, members: Array(selectedMembers))
        
        var existingGroups: [ChatGroup] = []
        if let data = UserDefaults.standard.data(forKey: "chatGroups"),
           let decoded = try? JSONDecoder().decode([ChatGroup].self, from: data) {
            existingGroups = decoded
        }
        
        existingGroups.append(newGroup)
        
        if let encoded = try? JSONEncoder().encode(existingGroups) {
            UserDefaults.standard.set(encoded, forKey: "chatGroups")
        }
    }
}
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
