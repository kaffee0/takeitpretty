//
//  BackgroundView.swift
//  Kaffee
//
//  Created by Kae Feuring on 2025/02/05.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack{
            Color(red: 229/255, green: 151/255, blue: 178/255)
                .ignoresSafeArea()
            PulsingStars(count: 20)
        }
    }
}

#Preview {
    BackgroundView()
}
