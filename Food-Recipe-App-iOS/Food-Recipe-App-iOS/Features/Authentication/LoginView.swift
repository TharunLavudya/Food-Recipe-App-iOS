import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: AuthViewModel

    @State private var rememberMe = false
    @State private var showResetAlert = false
    @State private var resetEmail = ""
    @State private var showResetSuccessAlert = false
    @State private var resetMessage: String?

    @State private var isPasswordVisible = false

    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 65))
                .foregroundColor(.green)
                .padding(.bottom, 5)

            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome Back")
                    .font(.largeTitle.bold())
                
                Text("Sign in to continue cooking")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 18) {
                
                // Email Field
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.green)
                    
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .padding()
                .background(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            viewModel.emailError == nil ? Color.clear : Color.red,
                            lineWidth: 1
                        )
                )
                .cornerRadius(12)
                
                if let emailError = viewModel.emailError {
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Password Field
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.green)
                    
                    if isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                    
                    Spacer()
                    
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Remember Me + Forgot
                HStack {
                    Toggle(isOn: $rememberMe) {
                        Text("Remember Me")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    
                    Spacer()
                    
                    Button("Forgot Password?") {
                        resetEmail = viewModel.email
                        showResetAlert = true
                    }
                    .font(.footnote)
                    .foregroundColor(.orange)
                }
                
                if let error = viewModel.generalError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
    
                Button {
                    Task {
                        await viewModel.signIn()
                        
                        if rememberMe {
                            UserDefaults.standard.set(viewModel.email, forKey: "savedEmail")
                            UserDefaults.standard.set(viewModel.password, forKey: "savedPassword")
                        } else {
                            UserDefaults.standard.removeObject(forKey: "savedEmail")
                            UserDefaults.standard.removeObject(forKey: "savedPassword")
                        }
                    }
                } label: {
                    Text("Sign In")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                
                // Signup Navigation
                NavigationLink {
                    SignupView(viewModel: viewModel)
                } label: {
                    Text("Don’t have an account? Sign up")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.08), radius: 10)
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
        
        // Remember Me Load
        .onAppear {
            if let savedEmail = UserDefaults.standard.string(forKey: "savedEmail"),
               let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") {
                viewModel.email = savedEmail
                viewModel.password = savedPassword
                rememberMe = true
            } else {
                viewModel.email = ""
                viewModel.password = ""
                rememberMe = false
            }
        }
        
        // Reset Alert
        .alert("Reset Password", isPresented: $showResetAlert) {
            TextField("Enter your email", text: $resetEmail)
            
            Button("Send") {
                Task {
                    do {
                        try await viewModel.sendPasswordReset(email: resetEmail)
                        showResetSuccessAlert = true
                    } catch {
                        resetMessage = error.localizedDescription
                    }
                }
            }
            
            Button("Cancel", role: .cancel) {}
            
        } message: {
            Text("We will send a reset link to your email.")
        }
        
        //  Success Alert
        .alert("Success", isPresented: $showResetSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Reset email has been sent to your mail id.")
        }
    }
}
