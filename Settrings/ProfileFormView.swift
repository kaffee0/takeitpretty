//
//  ProfileFormView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/13.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileFormView: View {
    @Binding var username: String
    @Binding var email: String
    @Binding var usernameErrorMessage: String?
    @Binding var emailErrorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            TextField("Username", text: $username)
                .font(.custom("American Typewriter", size: 20))
                .padding(25)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 3)
                .frame(width: 300)
                .autocapitalization(.none)

            if let usernameErrorMessage = usernameErrorMessage {
                HStack {
                    Text(usernameErrorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 12, design: .rounded))
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                }
            }

            TextField("Email", text: $email)
                .font(.custom("American Typewriter", size: 20))
                .padding(25)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 3)
                .frame(width: 300)
                .autocapitalization(.none)

            if let emailErrorMessage = emailErrorMessage {
                HStack {
                    Text(emailErrorMessage)
                        .foregroundColor(.red)
                        .font(.custom("American Typewriter", size: 20))
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            guard let user = Auth.auth().currentUser else { return }
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).getDocument { document, error in
                if let document = document, document.exists {
                    let storedUsername = document.get("username") as? String ?? ""
                    let storedEmail = document.get("email") as? String ?? ""

                    if username.isEmpty { username = storedUsername }
                    if email.isEmpty { email = storedEmail }
                }
            }
        }
    }
}
