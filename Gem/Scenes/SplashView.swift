// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.0

    var body: some View {
        ZStack {
          

            Image("splashscreen") 
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
        }
       
    }
}
