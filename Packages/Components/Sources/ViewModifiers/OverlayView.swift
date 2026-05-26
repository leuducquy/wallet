// Copyright (c). Gem Wallet. All rights reserved.
import SwiftUI


public protocol OverlayView: View {
    associatedtype Content: View
    @ViewBuilder var content: Content { get }
}

public extension OverlayView {
    var body: some View {
        ZStack(alignment: .top) {
           
            Image("splashscreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
              
            content
        
        }.background(Color.clear)
    }
}
