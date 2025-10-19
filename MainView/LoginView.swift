//
//  LoginView.swift
//  Kaffee
//
//  Created by Kae Feuring on 2025/10/17.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    var onLoginSuccess: () -> Void = {}

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 20) {
                Text("ログイン")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                if isLoading {
                    ProgressView()
                } else {
                    Button(action: login) {
                        Text("ログイン")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }

    private func login() {
        isLoading = true
        errorMessage = nil
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    // ログイン成功時の処理
                    print("ログイン成功")
                    onLoginSuccess()
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
