//
//  ChatDetailView.swift
//  MU Connect
//
//  Created by Niyathi on 5/5/25.
//

import SwiftUI

struct ChatDetailView: View {
    let chatWith: String
    let currentUser: String
    let name: String

    @State private var messages: [String] = []
    @State private var newMessage = ""

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(messages.indices, id: \.self) { index in
                            let msg = messages[index]
                            HStack {
                                if msg.starts(with: "\(currentUser):") {
                                    Spacer()
                                    Text(msg.replacingOccurrences(of: "\(currentUser):", with: ""))
                                        .padding(10)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                } else {
                                    Text(msg.replacingOccurrences(of: "\(chatWith):", with: ""))
                                        .padding(10)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                    scrollToBottom(proxy)
                }
            }

            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .padding(10)
                }
            }
            .padding()
        }
        .navigationTitle(name)
        .onAppear(perform: loadMessages)
    }

    func chatKey() -> String {
        let emails = [currentUser, chatWith].sorted()
        return "chat_\(emails[0])_\(emails[1])"
    }

    func loadMessages() {
        messages = UserDefaults.standard.stringArray(forKey: chatKey()) ?? []
    }

    func sendMessage() {
        guard !newMessage.isEmpty else { return }

        messages.append("\(currentUser):\(newMessage)")
        UserDefaults.standard.set(messages, forKey: chatKey())
        newMessage = ""
        loadMessages()
    }

    func scrollToBottom(_ proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let last = messages.indices.last {
                withAnimation {
                    proxy.scrollTo(last, anchor: .bottom)
                }
            }
        }
    }
}

#Preview {
    ChatDetailView(chatWith: "se21ucse456@mahindrauniversity.edu.in", currentUser: "se20ucse123@mahindrauniversity.edu.in", name: "Sample User")
}
