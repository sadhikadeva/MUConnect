import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var showSignup = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showPassword = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "graduationcap")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                    .padding(.top, 40)

                Text("MU Connect")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Building Bridges, Creating Opportunities.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if showPassword {
                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                } else {
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                Toggle("Show Password", isOn: $showPassword)
                    .padding(.horizontal)

                Button("Login") {
                    login()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)

                Button("Don't have an account? Sign up") {
                    showSignup = true
                }
                .padding(.top, 10)

                NavigationLink(destination: MainTabView(), isActive: $isLoggedIn) { EmptyView() }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showSignup) {
                SignUpView()
            }
        }
    }

    func login() {
        guard let data = UserDefaults.standard.data(forKey: "allUsers"),
              let users = try? JSONDecoder().decode([MUUser].self, from: data) else {
            alertMessage = "No users found."
            showAlert = true
            return
        }

        if let matchedUser = users.first(where: { $0.email == email && $0.password == password }) {
            UserDefaults.standard.set(matchedUser.email, forKey: "currentUser")
            isLoggedIn = true
        } else {
            alertMessage = "Invalid email or password."
            showAlert = true
        }
    }
}

