import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @State var user: MUUser

    @State private var bio: String = ""
    @State private var batch: String = ""
    @State private var imageData: String?
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingImagePicker = false

    @State private var dragOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0

    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Profile Picture")) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 200, height: 200)

                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .scaleEffect(scale)
                            .offset(dragOffset)
                            .gesture(
                                SimultaneousGesture(
                                    MagnificationGesture().onChanged { value in
                                        scale = value
                                    },
                                    DragGesture().onChanged { value in
                                        dragOffset = value.translation
                                    }
                                )
                            )
                    } else if let imageData = imageData,
                              let data = Data(base64Encoded: imageData),
                              let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    showingImagePicker = true
                }
            }

            Section(header: Text("Bio")) {
                TextField("Enter bio", text: $bio)
            }

            Section(header: Text("Batch")) {
                TextField("Enter batch", text: $batch)
            }

            Section {
                Button("Save Changes") {
                    var updatedUser = user
                    updatedUser.bio = bio
                    updatedUser.batch = batch
                    if let image = selectedImage {
                        updatedUser.profileImageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString()
                    }
                    saveUser(updatedUser)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Edit Profile")
        .onAppear {
            self.bio = user.bio
            self.batch = user.batch
            self.imageData = user.profileImageData
        }
        .photosPicker(isPresented: $showingImagePicker,
                      selection: $selectedItem,
                      matching: .images,
                      photoLibrary: .shared())
        .onChange(of: selectedItem) { newItem in
            if let item = newItem {
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        self.selectedImage = image
                        self.imageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString()
                        self.scale = 1.0
                        self.dragOffset = .zero
                    }
                }
            }
        }
    }

    func saveUser(_ updatedUser: MUUser) {
        if var users = loadAllUsers(),
           let index = users.firstIndex(where: { $0.email == updatedUser.email }) {
            users[index] = updatedUser
            if let encoded = try? JSONEncoder().encode(users) {
                UserDefaults.standard.set(encoded, forKey: "allUsers")
            }
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

