import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    @State private var showSignUp = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to MU Connect")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)

            if isPasswordVisible {
                TextField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Toggle("Show Password", isOn: $isPasswordVisible)
                .toggleStyle(SwitchToggleStyle(tint: .blue))

            Button("Login") {
                let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

                let users = UserDefaults.standard.dictionary(forKey: "users") as? [String: [String: String]] ?? [:]

                if let user = users[trimmedEmail], user["password"] == trimmedPassword {
                    UserDefaults.standard.set(trimmedEmail, forKey: "currentUser")
                    isLoggedIn = true
                } else {
                    alertMessage = "Invalid email or password"
                    showAlert = true
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Don't have an account? Sign up") {
                showSignUp = true
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
            MainTabView()
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpView()
        }
    }
}

#Preview {
    LoginView()
}
