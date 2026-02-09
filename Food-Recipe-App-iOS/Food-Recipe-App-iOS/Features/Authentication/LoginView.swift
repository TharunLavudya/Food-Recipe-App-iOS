import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: AuthViewModel
    @State private var showResetAlert = false
    @State private var resetEmail = ""
    @State private var resetMessage: String?
    
    // Remember Me
    @State private var rememberMe = false
    
    // Eye toggle state
    @State private var isPasswordVisible = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Hello,")
                    .font(.largeTitle).bold()
                Text("Welcome Back!")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Email
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            // Password with eye toggle
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $viewModel.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    SecureField("Password", text: $viewModel.password)
                }

                Spacer()

                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // Remember Me and  Forgot Password row
            HStack {
                Toggle("Remember Me", isOn: $rememberMe)
                    .font(.footnote)

                Spacer()

                Button("Forgot Password?") {
                    resetEmail = viewModel.email
                    showResetAlert = true
                }
                .font(.footnote)
                .foregroundColor(.orange)
            }

            // Error / Success messages
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            if let msg = resetMessage {
                Text(msg)
                    .foregroundColor(.green)
                    .font(.footnote)
            }
            
            // Sign In button
            Button {
                Task {
                    await viewModel.signIn()
                    
                    // Save or clear credentials based on Remember Me
                    if rememberMe {
                        UserDefaults.standard.set(viewModel.email, forKey: "savedEmail")
                        UserDefaults.standard.set(viewModel.password, forKey: "savedPassword")
                    } else {
                        UserDefaults.standard.removeObject(forKey: "savedEmail")
                        UserDefaults.standard.removeObject(forKey: "savedPassword")
                    }
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Sign In →")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            
            // Go to Sign Up
            NavigationLink {
                SignupView(viewModel: AuthViewModel())
            } label: {
                Text("Don’t have an account? Sign up")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
        .onAppear {
            // Load saved credentials ONLY if user chose Remember Me before
            if let savedEmail = UserDefaults.standard.string(forKey: "savedEmail"),
               let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") {
                viewModel.email = savedEmail
                viewModel.password = savedPassword
                rememberMe = true
            } else {
                // Ensure fields are empty by default
                viewModel.email = ""
                viewModel.password = ""
                rememberMe = false
            }
        }
        .alert("Reset Password", isPresented: $showResetAlert) {
            TextField("Enter your email", text: $resetEmail)
            Button("Send") {
                Task {
                    await sendPasswordReset()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("We will send a reset link to your email.")
        }
    }
    
    // Password Reset
    private func sendPasswordReset() async {
        do {
            try await viewModel.sendPasswordReset(email: resetEmail)
            resetMessage = "Password reset email sent."
        } catch {
            resetMessage = error.localizedDescription
        }
    }
}
