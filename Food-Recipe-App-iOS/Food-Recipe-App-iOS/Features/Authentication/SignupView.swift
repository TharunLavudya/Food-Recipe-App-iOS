import SwiftUI

struct SignupView: View {

    @ObservedObject var viewModel: AuthViewModel
    @State private var acceptTerms: Bool = false

    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    @State private var shake = false

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            VStack(alignment: .leading, spacing: 6) {
                Text("Create an account")
                    .font(.largeTitle.bold())

                Text("Sign up to get started")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 18) {

                // Name
                inputField(icon: "person.fill",
                           placeholder: "Name",
                           text: $viewModel.signupUsername)

                // Email
                inputField(icon: "envelope.fill",
                           placeholder: "Email",
                           text: $viewModel.email)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(viewModel.emailError == nil ? Color.clear : Color.red, lineWidth: 1)
                )

                if let emailError = viewModel.emailError {
                    errorText(emailError)
                }

                // Password
                passwordField(
                    icon: "lock.fill",
                    title: "Password",
                    text: $viewModel.password,
                    isVisible: $isPasswordVisible
                )

                // Animated Strength Section
                if !viewModel.password.isEmpty {
                    passwordStrengthView()
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                if let passwordError = viewModel.passwordError {
                    errorText(passwordError)
                }

                // Confirm Password
                passwordField(
                    icon: "lock.fill",
                    title: "Confirm Password",
                    text: $viewModel.confirmPassword,
                    isVisible: $isConfirmPasswordVisible
                )

                if let confirmError = viewModel.confirmPasswordError {
                    errorText(confirmError)
                }

                if let success = viewModel.successMessage {
                    Text(success)
                        .foregroundColor(.green)
                        .font(.footnote)
                }

                // Terms
                Toggle(isOn: $acceptTerms) {
                    Text("I accept terms & conditions")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .toggleStyle(SwitchToggleStyle(tint: .green))

                // Sign Up Button
                Button {
                    if !acceptTerms {
                        triggerShake()
                        return
                    }

                    Task {
                        await viewModel.signUp()
                        
                        if viewModel.generalError != nil {
                            triggerShake()
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(acceptTerms ? Color.green : Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .disabled(!acceptTerms)
                .modifier(ShakeEffect(animatableData: CGFloat(shake ? 1 : 0)))

                NavigationLink {
                    LoginView(viewModel: viewModel)
                } label: {
                    Text("Already have an account? Sign In")
                        .font(.footnote)
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
        .animation(.easeInOut(duration: 0.3), value: viewModel.password)
        .onAppear {
            clearFields()
        }
    }
    
    func inputField(icon: String,
                    placeholder: String,
                    text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)

            TextField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    func passwordField(
        icon: String,
        title: String,
        text: Binding<String>,
        isVisible: Binding<Bool>
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)

            if isVisible.wrappedValue {
                TextField(title, text: text)
            } else {
                SecureField(title, text: text)
            }

            Button {
                isVisible.wrappedValue.toggle()
            } label: {
                Image(systemName: isVisible.wrappedValue ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    func passwordStrengthView() -> some View {
        let strength = viewModel.passwordStrength(viewModel.password)
        let checks = viewModel.checkPassword(viewModel.password)

        let progress: CGFloat = {
            let score = [
                checks.hasUppercase,
                checks.hasLowercase,
                checks.hasNumber,
                checks.hasSpecial,
                checks.hasMinLength
            ].filter { $0 }.count
            return CGFloat(score) / 5.0
        }()

        return VStack(alignment: .leading, spacing: 6) {

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)

                RoundedRectangle(cornerRadius: 5)
                    .fill(progressColor(strength))
                    .frame(width: progress * 200, height: 6)
                    .animation(.easeInOut, value: progress)
            }

            Text("Strength: \(strengthText(strength))")
                .font(.footnote)
                .foregroundColor(progressColor(strength))

            ruleRow("Uppercase", checks.hasUppercase)
            ruleRow("Lowercase", checks.hasLowercase)
            ruleRow("Number", checks.hasNumber)
            ruleRow("Special character", checks.hasSpecial)
            ruleRow("At least 7 characters", checks.hasMinLength)
        }
    }
    func strengthText(_ strength: AuthViewModel.PasswordStrength) -> String {
        switch strength {
        case .weak: return "Weak"
        case .medium: return "Medium"
        case .strong: return "Strong"
        }
    }

    func progressColor(_ strength: AuthViewModel.PasswordStrength) -> Color {
        switch strength {
        case .weak: return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }

    func errorText(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.red)
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func clearFields() {
        viewModel.email = ""
        viewModel.password = ""
        viewModel.confirmPassword = ""
        viewModel.signupUsername = ""

        viewModel.emailError = nil
        viewModel.passwordError = nil
        viewModel.confirmPasswordError = nil
        viewModel.generalError = nil
        viewModel.successMessage = nil
    }
    private func triggerShake() {
        withAnimation(.default) {
            shake.toggle()
        }
    }
    func ruleRow(_ title: String, _ ok: Bool) -> some View {
        HStack {
            Image(systemName: ok ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(ok ? .green : .red)
                .font(.system(size: 14))

            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
    
}
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0
            )
        )
    }
}
