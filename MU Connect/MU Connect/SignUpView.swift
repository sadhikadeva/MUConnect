import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var batch = ""
    @State private var email = ""
    @State private var password = ""
    @State private var bio = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSignedUp = false
    @State private var confirmPassword = ""

    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email (use @mahindrauniversity.edu.in)", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Sign Up") {
                    signUp()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $isSignedUp) {
                MainTabView() // Replace with your main app view
            }
        }
    }
    
    func signUp() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard trimmedEmail.hasSuffix("@mahindrauniversity.edu.in") else {
            alertMessage = "Please use a Mahindra University email."
            showAlert = true
            return
        }
        
        guard !name.isEmpty && !password.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        var users = loadAllUsers()
        
        if users.contains(where: { $0.email == trimmedEmail }) {
            alertMessage = "Account already exists. Please log in."
            showAlert = true
            return
        }
        
        let newUser = MUUser(name: name, email: trimmedEmail, password: password)
        users.append(newUser)
        
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: "allUsers")
            UserDefaults.standard.set(trimmedEmail, forKey: "currentUser")
            isSignedUp = true
        } else {
            alertMessage = "Failed to save user."
            showAlert = true
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
