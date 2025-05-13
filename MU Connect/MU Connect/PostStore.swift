//
//  PostStore.swift
//  MU Connect
//
//  Created by Niyathi on 5/9/25.
//

import Foundation

class PostStore: ObservableObject {
    @Published var posts: [String] = []

    private let postsKey = "posts"

    init() {
        loadPosts()
    }

    func addPost(_ text: String) {
        posts.append(text)
        savePosts()
    }

    private func savePosts() {
        UserDefaults.standard.set(posts, forKey: postsKey)
    }

    private func loadPosts() {
        posts = UserDefaults.standard.stringArray(forKey: postsKey) ?? []
    }
}
