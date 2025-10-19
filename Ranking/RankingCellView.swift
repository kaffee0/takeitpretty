//
//  RankingCellView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/28.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RankingCellView: View {
    var rank: Int
    var username: String
    var score: Int
    @State private var iconName: String = "person.circle.fill"
    @State private var iconColor: Color = .gray
    
    var isCurrentUser: Bool {
        return username == Auth.auth().currentUser?.displayName
    }

    var body: some View {
        HStack {
            Text("\(rank).")
                .font(.custom("American Typewriter", size: 20))
                .foregroundColor(.gray)
            ZStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(iconColor)
            }
            .padding(3)
            
            Text(username)
                .font(.custom("American Typewriter", size: 27))
            Spacer()
            HStack(alignment: .firstTextBaseline) {
                Text("\(score)")
                    .font(.custom("American Typewriter", size: 27))
                    .foregroundColor(Color(red: 108/255, green: 145/255, blue: 235/255))
                Text("pts")
                    .font(.custom("American Typewriter", size: 27))
                    .foregroundColor(Color(red: 108/255, green: 145/255, blue: 235/255))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
        .drawingGroup()
        .onAppear {
            fetchUserIconData()
        }
    }
    
    private func fetchUserIconData() {
        guard !username.isEmpty else { return }
        let db = Firestore.firestore()

        db.collection("users").whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            if let document = snapshot?.documents.first {
                DispatchQueue.main.async {
                    if let fetchedIconName = document.get("iconName") as? String {
                        self.iconName = fetchedIconName
                    }
                    if let iconColorHex = document.get("iconColor") as? String {
                        self.iconColor = .gray
                    }
                }
            } else {
                print("Firestoreからアイコンデータを取得できませんでした: \(error?.localizedDescription ?? "不明なエラー")")
            }
        }
    }
}
