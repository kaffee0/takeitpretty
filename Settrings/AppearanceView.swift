//
//  AppearanceSettingView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/13.
//

import SwiftUI

struct AppearanceView: View {
    @AppStorage("selectedFont") private var selectedFont = "American Typewriter"
    @AppStorage("selectedFontSize") private var selectedFontSize = 28.0
    @AppStorage("soundEnabled") private var soundEnabled = true
    
    let fonts = [
        "Arial",
        "ArialRoundedMTBold",
        "Avenir Next",
        "American Typewriter",
        "Chalkboard",
        "Didot",
        "Bansyu-retoromin-R",
        "Kinkakuji-Normal",
        "sharp-logo",
        "Times New Roman",
        "YDWyadewanoji",
        "YokohamaDotsJPN-Regular"
    ]

    var body: some View {
        ZStack{
            VStack {
                Spacer()
                TileDesignView(tile: Tile(line1: 9, line2: 7, line3: 8), size: 250, fontScale: 0.25, neonLine1: false, neonLine2: false, neonLine3: false)
                    .padding()
                
                Picker("フォント", selection: $selectedFont) {
                    ForEach(fonts, id: \.self) { font in
                        Text(font).font(.custom(font, size: 22))
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .padding(30)
                
                Toggle("サウンドを有効にする", isOn: $soundEnabled)
                    .padding(.bottom, 40)
                    .padding(30)
                    .font(.custom("American Typewriter", size: 20))
            }
            .transaction { $0.animation = nil }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    AppearanceView()
}
