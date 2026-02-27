import SwiftUI

struct StartCookingView: View {

    let recipe: Recipe
    @State private var currentStep = 0
    @State private var showSuccess = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {

            // Background
            Color.green.opacity(0.04)
                .ignoresSafeArea()

            VStack {

                VStack(spacing: 10) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 55))
                        .foregroundColor(.green)
                        .shadow(color: .green.opacity(0.5), radius: 8)

                    Text("COOKING MODE")
                        .font(.title2)
                        .bold()
                        .tracking(2)
                }
                .padding(.top, 20)

                Spacer()

                VStack(spacing: 20) {

                    Text("STEP \(currentStep + 1) / \(recipe.instructions.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(recipe.instructions[currentStep])
//                        .font(.title2)
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundStyle(.primary)
//                        .fontWeight(.semibold)
//                        .font(.italic)
                        .multilineTextAlignment(.center)
                        .padding(25)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(.systemBackground))
                                .shadow(color: .green.opacity(0.1), radius: 10)
                        )
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }

                Spacer()

                HStack(spacing: 30) {

                    // Previous
                    Button {
                        if currentStep > 0 {
                            currentStep -= 1
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.4))
                            .clipShape(Circle())
                    }

                    // Next & Finish
                    Button {
                        if currentStep < recipe.instructions.count - 1 {
                            currentStep += 1
                        } else {
                            showSuccess = true
                        }
                    } label: {
                        Image(systemName: currentStep == recipe.instructions.count - 1 ? "checkmark" : "arrow.right")
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(color: .green.opacity(0.6), radius: 8)
                    }
                }
                .padding(.bottom, 25)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .alert("Recipe Completed!", isPresented: $showSuccess) {
            Button("Yayyy!") {
                dismiss()
            }
        } message: {
            Text("You have successfully made \(recipe.name)! Wohoooo! ")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.green)
                }
            }
        }
    }
}
