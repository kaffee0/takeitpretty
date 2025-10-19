//
//  IconPickerView 2.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/13.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct IconPickerView: View {
    
    @Binding var selectedIcon: String
    @Binding var showingIconPicker: Bool
    @Binding var selectedColor: Color

    let colorOptions: [Color] = [ .pink, .red, .orange, .yellow, .green, .mint, .cyan,
                                  .blue, .purple,]

    let systemIcons = [
//      Persons
        "person.circle.fill","person.fill","person.fill.turn.right",
        "person.fill.turn.down","person.fill.turn.left","poweroutlet.type.k.fill",
        "figure.stand.dress","figure.arms.open","figure","figure.walk","figure.run",
        "figure.fall","figure.strengthtraining.traditional",
        "eye.fill","hand.raised.fill","brain.fill",
//      Sports
        "dumbbell.fill","soccerball","baseball.fill","basketball.fill",
        "volleyball.fill","american.football.fill","rugbyball.fill","tennis.racket",
        "skateboard.fill",
//      Weather
        "sun.max.fill","cloud.fill","cloud.sun.fill","cloud.snow.fill",
        "cloud.sleet.fill","flame.fill","moon.fill","moon.stars.fill",
        "star.fill","bolt.fill","heart.fill","bolt.heart.fill",
//      Nature
        "dog.fill","lizard.fill","tortoise.fill","hare.fill","bird.fill","ladybug.fill",
        "fish.fill","fossil.shell.fill","pawprint.fill","camera.macro","leaf.fill",
        "tree.fill","carrot.fill","atom",
        
        "house.fill","fan.desk.fill","book.fill","lamp.desk.fill","spigot.fill",
        "paintbrush.fill","gamecontroller.fill","trash.fill","balloon.fill",
        "popcorn.fill","toilet.fill","music.note",
        "bell.fill","gift.fill","key.fill","lock.fill","eraser.fill",
        "externaldrive.connected.to.line.below.fill","graduationcap.fill",
        
        "car.fill","car.rear.fill","car.side.fill","convertible.side.fill",
        "truck.pickup.side.fill","suv.side.fill","oilcan.fill","airplane",
        "bus.fill","tram.fill","cablecar.fill","ferry.fill","sailboat.fill","bicycle",
        "moped.fill","motorcycle.fill","scooter",
        "carbon.monoxide.cloud.fill","carbon.dioxide.cloud.fill",
    ]

    var body: some View {
        VStack {
            Text("Choose an Icon")
                .font(.custom("American Typewriter", size: 30))
                .padding(.top, 20)
            
            VStack(spacing: 20) {
                HStack(spacing: 13) {
                    ForEach(colorOptions.prefix(4), id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2))
                            .onTapGesture {
                                selectedColor = color
                                saveIconAndColor()
                            }
                    }
                }

                if colorOptions.count > 6 {
                    HStack(spacing: 13) {
                        ForEach(colorOptions.dropFirst(4), id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .overlay(Circle().stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2))
                                .onTapGesture {
                                    selectedColor = color
                                    saveIconAndColor()
                                }
                        }
                    }
                }
            }
            .padding(.bottom, 5)
            .padding(2)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 15) {
                    ForEach(systemIcons, id: \.self) { icon in
                        Image(systemName: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(selectedColor)
                            .padding()
                            .background(selectedIcon == icon ? selectedColor.opacity(0.2) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                selectedIcon = icon
                                saveIconAndColor()
                            }
                    }
                }
                .padding()
            }

            Button("Close") {
                showingIconPicker = false
            }
            .padding()
        }
        .onAppear {
            loadUserData()
        }
    }

    private func saveIconAndColor() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()

        db.collection("users").document(user.uid).updateData([
            "iconName": selectedIcon,
            "iconColor": selectedColor.toHex() // Store as hex string
        ])
    }

    private func loadUserData() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()

        db.collection("users").document(user.uid).getDocument { document, error in
            if let document = document, document.exists {
                if let iconName = document.get("iconName") as? String {
                    selectedIcon = iconName
                }
                if let iconColorHex = document.get("iconColor") as? String {
                    if let color = Color(hex: iconColorHex) {
                        selectedColor = color
                    } else {
                        selectedColor = .gray // Fallback to a default color
                    }
                }
            }
        }
    }
}

#Preview {
    IconPickerView(selectedIcon: .constant("person.circle.fill"), showingIconPicker: .constant(true), selectedColor: .constant(.blue))
}
