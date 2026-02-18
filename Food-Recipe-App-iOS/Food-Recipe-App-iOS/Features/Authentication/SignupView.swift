import SwiftUI

struct SignupView: View {

    @ObservedObject var viewModel: AuthViewModel
    @State private var name: String = ""
    @State private var acceptTerms: Bool = false

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

            TextField("Name", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

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

            // Password
            passwordField(
                title: "Password",
                text: $viewModel.password,
                isVisible: $isPasswordVisible
            )

            passwordStrengthView()

            if let passwordError = viewModel.passwordError {
                Text(passwordError).foregroundColor(.red).font(.footnote)
            }

            // Confirm Password
            passwordField(
                title: "Confirm Password",
                text: $viewModel.confirmPassword,
                isVisible: $isConfirmPasswordVisible
            )

            if let confirmError = viewModel.confirmPasswordError {
                Text(confirmError).foregroundColor(.red).font(.footnote)
            }

            if let success = viewModel.successMessage {
                Text(success).foregroundColor(.green).font(.footnote)
            }

            Toggle(isOn: $acceptTerms) {
                Text("I accept terms & conditions").font(.footnote)
            }

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
    }

    // Components

    func passwordField(title: String, text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        HStack {
            if isVisible.wrappedValue {
                TextField(title, text: text)
            } else {
                SecureField(title, text: text)
            }

            Button {
                isVisible.wrappedValue.toggle()
            } label: {
                Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    func passwordStrengthView() -> some View {
        let strength = viewModel.passwordStrength(viewModel.password)

        let (text, color): (String, Color) = {
            switch strength {
            case .weak: return ("Weak", .red)
            case .medium: return ("Medium", .orange)
            case .strong: return ("Strong", .green)
            }
        }()

        return VStack(alignment: .leading, spacing: 4) {
            Text("Strength: \(text)")
                .foregroundColor(color)
                .font(.footnote)

            let checks = viewModel.checkPassword(viewModel.password)

            ruleRow("Uppercase", checks.hasUppercase)
            ruleRow("Lowercase", checks.hasLowercase)
            ruleRow("Number", checks.hasNumber)
            ruleRow("Special character", checks.hasSpecial)
            ruleRow("At least 7 characters", checks.hasMinLength)
        }
    }

    func ruleRow(_ title: String, _ ok: Bool) -> some View {
        HStack {
            Image(systemName: ok ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(ok ? .green : .red)
            Text(title).font(.footnote)
        }
    }
}
