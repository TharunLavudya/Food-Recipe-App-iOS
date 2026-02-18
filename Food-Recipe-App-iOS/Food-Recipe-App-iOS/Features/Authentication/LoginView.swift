import SwiftUI

struct LoginView: View {

    @StateObject var viewModel: AuthViewModel

    // Remember Me
    @State private var rememberMe = false

    @State private var showResetAlert = false
    @State private var resetEmail = ""
    @State private var showResetSuccessAlert = false
    @State private var resetMessage: String?

    @State private var isPasswordVisible = false
    @State private var isCapsLockOn = false

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
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.emailError == nil ? Color.clear : Color.red, lineWidth: 1)
                )
                .cornerRadius(10)
                .onChange(of: viewModel.email) { _ in
                    if viewModel.isValidGmail(viewModel.email) {
                        viewModel.emailError = nil
                    }
                }

            if let emailError = viewModel.emailError {
                Text(emailError).foregroundColor(.red).font(.footnote)
            }

            // Password + eye symbol
            HStack {
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
            .cornerRadius(10)

            if isCapsLockOn {
                Text("Caps Lock is ON").foregroundColor(.orange).font(.footnote)
            }

            // Remember Me + Forgot Password Row
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

            if let error = viewModel.generalError {
                Text(error).foregroundColor(.red).font(.footnote)
            }

            // Sign In Button
            Button {
                Task {
                    await viewModel.signIn()

                    //  Remember Me logic 
                    if rememberMe {
                        UserDefaults.standard.set(viewModel.email, forKey: "savedEmail")
                        UserDefaults.standard.set(viewModel.password, forKey: "savedPassword")
                    } else {
                        UserDefaults.standard.removeObject(forKey: "savedEmail")
                        UserDefaults.standard.removeObject(forKey: "savedPassword")
                    }
                }
            } label: {
                Text("Sign In →")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

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

        // Load saved credentials 
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

        // Reset password alert
        .alert("Reset Password", isPresented: $showResetAlert) {
            TextField("Enter your email", text: $resetEmail)
            Button("Send") {
                Task {
                    do {
                        try await viewModel.sendPasswordReset(email: resetEmail)
                        resetMessage = "Password reset email sent."
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

        // Success popup
        .alert("Success", isPresented: $showResetSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Reset email has been sent to your mail id.")
        }
    }
}
