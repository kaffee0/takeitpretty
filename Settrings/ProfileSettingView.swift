//
//  IconPickerView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/13.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var isUpdating = false
    @State private var errorMessage: String?
    @State private var usernameErrorMessage: String?
    @State private var emailErrorMessage: String?
    @AppStorage("selectedIcon") private var selectedIcon: String = "person.circle.fill"
    @State private var selectedColor: Color = .gray
    @State private var showingIconPicker = false

    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                Spacer()
                
                ProfileIconView(selectedIcon: $selectedIcon, selectedColor: $selectedColor, showingIconPicker: $showingIconPicker)

                ProfileFormView(username: $username, email: $email, usernameErrorMessage: $usernameErrorMessage, emailErrorMessage: $emailErrorMessage)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.custom("American Typewriter", size: 20))
                }

                if isUpdating {
                    ProgressView()
                } else {
                    BasicButton(
                        title: "Update Profile",
                        customFont: .custom("American Typewriter", size: 20),
                        foregroundColor: .white,
                        gradientColors: [Color.blue, Color.cyan],
                        animateButton: true,
                        frameWidth: 200,
                        action: updateProfile
                    )
                }
                Spacer()
            }
        }
    }

    private func loadUserData() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { document, error in
            if let document = document, document.exists {
                let newUsername = document.get("username") as? String ?? ""
                let newEmail = document.get("email") as? String ?? ""
                let newIcon = document.get("iconName") as? String ?? "person.circle.fill"
                let newColorHex = document.get("iconColor") as? String ?? "#808080"

                // Firestore の文字列を Color に変換
                if let color = Color(hex: newColorHex) {
                    selectedColor = color
                }

                if username != newUsername { username = newUsername }
                if email != newEmail { email = newEmail }
                if selectedIcon != newIcon { selectedIcon = newIcon }
            }
        }
    }

    private func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }
        isUpdating = true
        errorMessage = nil
        usernameErrorMessage = nil
        emailErrorMessage = nil

        let db = Firestore.firestore()

        db.collection("users").document(user.uid).updateData([
            "username": username,
            "iconName": selectedIcon,
            "iconColor": selectedColor.toHex()
        ]) { error in
            if let error = error {
                self.errorMessage = "Failed to update profile: \(error.localizedDescription)"
                self.isUpdating = false
                return
            }
        }

        Task {
            do {
                try await user.sendEmailVerification(beforeUpdatingEmail: email)
                // Update Firestore email field after successful verification request
                do {
                    try await db.collection("users").document(user.uid).updateData(["email": email])
                    self.isUpdating = false
                    appState.hasLoggedIn = true
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } catch {
                    self.isUpdating = false
                    self.errorMessage = "Failed to update email in database: \(error.localizedDescription)"
                }
            } catch {
                self.errorMessage = "Failed to send verification before updating email: \(error.localizedDescription)"
                self.isUpdating = false
            }
        }
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }

    func toHex() -> String {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
