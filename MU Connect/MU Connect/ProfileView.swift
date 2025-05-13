

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var user: MUUser?
    @State private var userPosts: [Post] = []
    @State private var isEditingProfile = false
    @State private var isLoggedOut = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if let user = user {
                        if let imageData = user.profileImageData,
                           let data = Data(base64Encoded: imageData),
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        }

                        Text(user.name)
                            .font(.title)
                            .bold()

                        Text(user.email)
                            .foregroundColor(.gray)

                        Text("Bio: \(user.bio)")
                        Text("Batch: \(user.batch)")

                        Button("Edit Profile") {
                            isEditingProfile = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Logout") {
                            UserDefaults.standard.removeObject(forKey: "currentUser")
                            isLoggedOut = true
                        }
                        .padding()
                        .foregroundColor(.red)

                        Divider()

                        Text("My Posts")
                            .font(.headline)

                        ForEach(userPosts.reversed()) { post in
                            if let image = post.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.bottom, 4)
                            }
                            Text(post.caption)
                                .font(.subheadline)
                                .padding(.bottom, 10)
                        }
                    } else {
                        ProgressView("Loading profile...")
                    }
                }
                .padding()
            }
            .navigationTitle("My Profile")
            .onAppear {
                loadCurrentUser()
                loadUserPosts()
            }
            .sheet(isPresented: $isEditingProfile, onDismiss: {
                loadCurrentUser()
                loadUserPosts()
            }) {
                if let user = user {
                    EditProfileView(user: user)
                }
            }
            .background(
                NavigationLink(destination: LoginView(), isActive: $isLoggedOut) {
                    EmptyView()
                }
            )
        }
    }

    func loadCurrentUser() {
        guard let email = UserDefaults.standard.string(forKey: "currentUser"),
              let data = UserDefaults.standard.data(forKey: "allUsers"),
              let users = try? JSONDecoder().decode([MUUser].self, from: data),
              let matched = users.first(where: { $0.email == email }) else {
            return
        }
        self.user = matched
    }

    func loadUserPosts() {
        guard let data = UserDefaults.standard.data(forKey: "posts"),
              let allPosts = try? JSONDecoder().decode([Post].self, from: data),
              let email = UserDefaults.standard.string(forKey: "currentUser") else {
            return
        }
        self.userPosts = allPosts.filter { $0.authorEmail == email }
    }
}
