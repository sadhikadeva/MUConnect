import SwiftUI

struct UserProfileView: View {
    let user: MUUser

    @State private var isFollowing = false
    @State private var currentUserEmail: String = ""

    var body: some View {
        VStack(spacing: 16) {
            if let imageData = user.profileImageData,
               let data = Data(base64Encoded: imageData),
               let image = UIImage(data: data) {
                Image(uiImage: image)
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

            if !user.bio.isEmpty {
                Text("Bio: \(user.bio)")
            }

            if !user.batch.isEmpty {
                Text("Batch: \(user.batch)")
            }

            // Show Follow button only if not viewing own profile
            if user.email != currentUserEmail {
                Button(action: toggleFollow) {
                    Text(isFollowing ? "Following" : "Follow")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFollowing ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
        .onAppear {
            loadFollowStatus()
        }
    }

    // Load current user's following list and set isFollowing flag
    func loadFollowStatus() {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUser"),
              let data = UserDefaults.standard.data(forKey: "allUsers"),
              let users = try? JSONDecoder().decode([MUUser].self, from: data),
              let currentUser = users.first(where: { $0.email == currentEmail }) else {
            return
        }

        currentUserEmail = currentEmail
        isFollowing = currentUser.following.contains(user.email)
    }

    // Toggle follow/unfollow and save changes to UserDefaults
    func toggleFollow() {
        guard let currentEmail = UserDefaults.standard.string(forKey: "currentUser"),
              var users = try? JSONDecoder().decode([MUUser].self, from: UserDefaults.standard.data(forKey: "allUsers") ?? Data()),
              let currentIndex = users.firstIndex(where: { $0.email == currentEmail }) else {
            return
        }

        var currentUser = users[currentIndex]

        if isFollowing {
            currentUser.following.removeAll { $0 == user.email }
        } else {
            currentUser.following.append(user.email)
        }

        users[currentIndex] = currentUser

        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: "allUsers")
            isFollowing.toggle()
        }
    }
}

