// Copyright (c). Gem Wallet. All rights reserved.

import Foundation
import SwiftUI
import Style
import Components
import Localization
import Primitives

struct SecurityReminderScene: OverlayView {
    @State private var model: SecurityReminderViewModel
    
    init(model: SecurityReminderViewModel) {
        self.model = model
    }
    
    var content: some View {
        ZStack {
            Image("splashscreen")
                       .resizable()
                       .scaledToFill()
                       .ignoresSafeArea()

            List {
                CalloutView(style: .header(title: model.message))
                    .cleanListRow()
                
                ForEach(model.items) { item in
                    Section {
                        ListItemView(
                            title: TextValue(text: item.title, style: .whiteText),
                            titleExtra: TextValue(text: item.subtitle, style: .whiteText),
                            imageStyle: item.image
                        )
                    }.listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden) 
            .safeAreaView {
               
                PrimaryGradientButton(title: Localized.Common.continue) {
                    model.onNext()
                } .padding(.horizontal, 10)
                    .frame(maxWidth: .scene.button.maxWidth)
                    .padding(.bottom, .scene.bottom * 15)
                }
           
            
            
          
            .contentMargins([.top], .extraSmall, for: .scrollContent)
            .listSectionSpacing(.custom(.medium))
            .navigationTitle(model.title)
            .toolbarTitleDisplayMode(.inline)
           // .toolbarInfoButton(url: model.docsUrl)
           
        }
        }
      
}

#Preview {
    SecurityReminderScene(
        model: SecurityReminderViewModelDefault(
            title: Localized.Wallet.New.title,
            onNext: {}
        )
    )
}
