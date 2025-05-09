import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @State private var bio = ""
    @State private var batch = ""
    @State private var selectedImage: UIImage?
    @State private var imageData: String?
    @State private var showingImagePicker = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Profile Picture")) {
                Button("Choose Profile Image") {
                    showingImagePicker = true
                }
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }

            Section(header: Text("Bio")) {
                TextField("Enter bio", text: $bio)
            }

            Section(header: Text("Batch")) {
                TextField("Enter batch", text: $batch)
            }

            Button("Save Profile") {
                saveProfile()
                dismiss()
            }
            .foregroundColor(.blue)
        }
        
        .onAppear {
            loadProfile()
        }
    }

    func saveProfile() {
        let email = UserDefaults.standard.string(forKey: "currentUser") ?? ""
        var users = loadAllUsers()  // ✅ move this UP

        // Now you can safely use 'users'
        let password = users.first(where: { $0.email == email })?.password ?? ""

        var user = MUUser(name: email, email: email, password: password)
        user.bio = bio
        user.batch = batch
        user.profileImageData = imageData

        if let index = users.firstIndex(where: { $0.email == email }) {
            users[index] = user
        } else {
            users.append(user)
        }

        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: "allUsers")
            print("✅ Profile saved for \(email)")
        } else {
            print("❌ Failed to encode and save users")
        }
    }


    func loadProfile() {
        let email = UserDefaults.standard.string(forKey: "currentUser") ?? ""
        let users = loadAllUsers()
        if let user = users.first(where: { $0.email == email }) {
            bio = user.bio
            batch = user.batch
            if let imageData = user.profileImageData,
               let data = Data(base64Encoded: imageData),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
                self.imageData = imageData
            }
        }
    }

    func loadAllUsers() -> [MUUser] {
        if let data = UserDefaults.standard.data(forKey: "allUsers"),
           let users = try? JSONDecoder().decode([MUUser].self, from: data) {
            return users
        }
        return []
    }
}
