import SwiftUI

struct SignupView: View {

    @ObservedObject var viewModel: AuthViewModel
    @State private var name: String = ""
    @State private var acceptTerms: Bool = false

    // Eye toggle states
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(alignment: .leading, spacing: 6) {
                Text("Create an account")
                    .font(.largeTitle).bold()
                Text("Sign up to get started")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Name
            TextField("Name", text: $name)
                .textInputAutocapitalization(.words)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            // Email
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            //  Password with eye toggle
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $viewModel.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    SecureField("Password", text: $viewModel.password)
                }

                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            //  Confirm Password with eye toggle
            HStack {
                if isConfirmPasswordVisible {
                    TextField("Confirm Password", text: $viewModel.confirmPassword)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                }

                Button {
                    isConfirmPasswordVisible.toggle()
                } label: {
                    Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // Error message
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            if let success = viewModel.successMessage {
                Text(success)
                    .foregroundColor(.green)
                    .font(.footnote)
            }


            // Accept terms
            Toggle(isOn: $acceptTerms) {
                Text("I accept terms & conditions")
                    .font(.footnote)
            }

            // Sign Up button
            Button {
                Task { await viewModel.signUp() }
            } label: {
                Text("Sign Up →")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(acceptTerms ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(!acceptTerms)
            NavigationLink {
                LoginView(viewModel: AuthViewModel())
            } label: {
                Text("Already have an account? Sign In")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}
