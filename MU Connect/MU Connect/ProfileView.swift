import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var user: MUUser?
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if let user = user {
                    if let imageData = user.profileImageData,
                       let data = Data(base64Encoded: imageData),
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                    
                    Button("Edit Profile Picture") {
                        showImagePicker = true
                    }
                    NavigationLink(destination: EditProfileView(user: user)) {
                        Text("Edit Profile")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    
                    Text(user.name)
                        .font(.title)
                        .bold()
                    
                    Text(user.email)
                        .foregroundColor(.gray)
                    
                    Text("Bio: \(user.bio)")
                        .padding(.top, 4)
                    
                    Text("Batch: \(user.batch)")
                } else {
                    ProgressView("Loading profile...")
                }
                
                Spacer()
            }
            .padding()
            .onAppear(perform: loadCurrentUser)
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Choose Profile Picture")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            .onChange(of: selectedItem, initial: false) { oldItem, newItem in
                if let item = newItem {
                    handleImagePickerResult(item)
                }
            }

            
        }
    }
    
    func loadCurrentUser() {
        guard let email = UserDefaults.standard.string(forKey: "currentUser") else {
            print("❌ No current user")
            return
        }
        
       
        guard let data = UserDefaults.standard.data(forKey: "allUsers") else {
            print("❌ No data found for 'allUsers' key")
            return
        }

        print("📦 Found allUsers data of size: \(data.count) bytes")

        do {
            let users = try JSONDecoder().decode([MUUser].self, from: data)
            if let email = UserDefaults.standard.string(forKey: "currentUser"),
               let matched = users.first(where: { $0.email == email }) {
                self.user = matched
                print("✅ Loaded user \(matched.email)")
            } else {
                print("❌ No matching user found for currentUser")
            }
        } catch {
            print("❌ JSON decode error: \(error.localizedDescription)")
        }

    }
    
    func handleImagePickerResult(_ item: PhotosPickerItem) {
        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage

                    guard var updatedUser = user else { return }

                    updatedUser.profileImageData = uiImage.jpegData(compressionQuality: 0.8)?.base64EncodedString()
                    saveUser(updatedUser)
                    self.user = updatedUser
                }
            } catch {
                print("❌ Failed to load image: \(error)")
            }
        }
    }


    
    func saveUser(_ updatedUser: MUUser) {
        guard var users = loadAllUsers(),
              let index = users.firstIndex(where: { $0.email == updatedUser.email }) else { return }
        
        users[index] = updatedUser
        
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: "allUsers")
        }
    }
    
    func loadAllUsers() -> [MUUser]? {
        if let data = UserDefaults.standard.data(forKey: "allUsers"),
           let users = try? JSONDecoder().decode([MUUser].self, from: data) {
            return users
        }
        return nil
    }
}
