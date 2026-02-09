import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: AuthViewModel
    @State private var showResetAlert = false
    @State private var resetEmail = ""
    @State private var resetMessage: String?
    
    //  Eye toggle state
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
            
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            //Password field with eye toggle (FIXED LAYOUT)
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $viewModel.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    SecureField("Password", text: $viewModel.password)
                }

                Spacer() // 👈 pushes eye button to the right

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


            // Forgot Password
            HStack {
                Spacer()
                Button("Forgot Password?") {
                    resetEmail = viewModel.email
                    showResetAlert = true
                }
                .font(.footnote)
                .foregroundColor(.orange)
            }

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
            
            Button {
                Task { await viewModel.signIn() }
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
            
            NavigationLink {
                SignupView(viewModel: viewModel)
            } label: {
                Text("Don’t have an account? Sign up")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
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
    
    // MARK: - Password Reset
    private func sendPasswordReset() async {
        do {
            try await viewModel.sendPasswordReset(email: resetEmail)
            resetMessage = "Password reset email sent."
        } catch {
            resetMessage = error.localizedDescription
        }
    }
}
