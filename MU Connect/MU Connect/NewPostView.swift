//
//  NewPostView.swift
//  MU Connect
//
//  Created by Niyathi on 4/28/25.
//

import SwiftUI

struct NewPostView: View {
    @State private var postText = ""
    @State private var showSuccessMessage = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Create a New Post")
                    .font(.title)
                    .bold()

                TextEditor(text: $postText)
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )

                Button(action: {
                    if !postText.isEmpty {
                        savePost(postText)
                        postText = ""
                        showSuccessMessage = true
                    }
                }) {
                    Text("Post")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)

                if showSuccessMessage {
                    Text("Post added successfully!")
                        .foregroundColor(.green)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Add Post")
        }
    }

    func savePost(_ text: String) {
        var posts = UserDefaults.standard.stringArray(forKey: "posts") ?? []
        posts.append(text)
        UserDefaults.standard.set(posts, forKey: "posts")
    }
}

#Preview {
    NewPostView()
}
