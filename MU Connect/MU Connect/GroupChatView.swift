import SwiftUI

struct GroupChatView: View {
    let group: ChatGroup
    @State private var messages: [String] = []
    @State private var newMessage: String = ""
    var body: some View {
        VStack {
            List(messages, id: \.self) { msg in
                Text(msg)
            }
            
            HStack {
                TextField("Type your message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Send") {
                    sendMessage()
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(group.name)
        .onAppear {
            loadMessages()
        }
    }
    
    func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        messages.append(newMessage)
        saveMessages()
        newMessage = ""
    }
    
    func loadMessages() {
        let key = "messages_\(group.id.uuidString)"
        if let data = UserDefaults.standard.data(forKey: key),
           let loaded = try? JSONDecoder().decode([String].self, from: data) {
            self.messages = loaded
        }
    }
    
    func saveMessages() {
        let key = "messages_\(group.id.uuidString)"
        if let encoded = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
