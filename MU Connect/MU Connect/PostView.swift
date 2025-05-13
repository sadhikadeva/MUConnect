
import SwiftUI
import PhotosUI
import UIKit
import Foundation


struct PostView: View {
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var caption: String = ""


    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button("Choose Image") {
                showingImagePicker = true
            }
            TextField("Write a caption...", text: $caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)


            Button("Post") {
                createPost()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(selectedImage: $selectedImage)
        }
    }

    func createPost() {
        guard let email = UserDefaults.standard.string(forKey: "currentUser") else { return }
        let newPost = Post(authorEmail: email, image: selectedImage, caption: caption)

        var posts = loadPosts()
        posts.append(newPost)

        if let encoded = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(encoded, forKey: "posts")
        }

        selectedImage = nil
    }

    func loadPosts() -> [Post] {
        guard let data = UserDefaults.standard.data(forKey: "posts"),
              let decoded = try? JSONDecoder().decode([Post].self, from: data)
        else { return [] }
        return decoded
    }
}
