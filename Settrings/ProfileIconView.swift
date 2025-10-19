//
//  IconPickerView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/13.
//

import SwiftUI
import Firebase
import FirebaseAuth

extension UserDefaults {
    func setColor(_ color: Color, forKey key: String) {
        if let components = UIColor(color).cgColor.components {
            self.set(components, forKey: key)
        }
    }

    func color(forKey key: String) -> Color? {
        guard let components = self.array(forKey: key) as? [CGFloat], components.count >= 3 else { return nil }
        return Color(red: components[0], green: components[1], blue: components[2])
    }
}

struct ProfileIconView: View {
    @Binding var selectedIcon: String
    @Binding var selectedColor: Color
    @Binding var showingIconPicker: Bool
    
    var body: some View {
        ZStack(alignment: .center){
            Circle()
                .stroke(.gray, lineWidth: 1)
                .frame(width: 140, height: 140)
            Image(systemName: selectedIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(20)
                .foregroundColor(selectedColor)
                .onTapGesture {
                    showingIconPicker.toggle()
                }
                .sheet(isPresented: $showingIconPicker) {
                    IconPickerView(selectedIcon: $selectedIcon, showingIconPicker: $showingIconPicker, selectedColor: $selectedColor)
                }
                .onAppear {
                    if selectedColor == .gray {
                        guard let user = Auth.auth().currentUser else { return }
                        let db = Firestore.firestore()
                        db.collection("users").document(user.uid).getDocument { document, error in
                            if let document = document, document.exists {
                                if let iconColorHex = document.get("iconColor") as? String {
                                    if let color = Color(hex: iconColorHex) {
                                        selectedColor = color
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    ProfileIconView(selectedIcon: .constant("person.fill"), selectedColor: .constant(.gray), showingIconPicker: .constant(false))
}
