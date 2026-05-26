// Copyright (c). Gem Wallet. All rights reserved.

import SwiftUI

public struct AppToggleStyle: ToggleStyle {
    
    var tintColor: Color
    
    public init(
        tintColor: Color = Colors.greenLight
    ) {
        self.tintColor = tintColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: .space12) {
            configuration.label
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? tintColor : Colors.gray)
                    .frame(width: 50, height: 30)
                Circle()
                    .fill(Colors.black)
                    .frame(width: 24, height: 24)
                    .offset(x: configuration.isOn ? 10 : -10)
            }
            .animation(.easeInOut(duration: 0.15), value: configuration.isOn)
        }
        .contentShape(Rectangle())
        .onTapGesture { configuration.isOn.toggle() }
    }
}

public struct CheckboxStyle: ToggleStyle {
    public enum CheckboxPosition {
        case left
        case right
    }
    
    let position: CheckboxPosition
    
    public init(position: CheckboxPosition) {
        self.position = position
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        HStack(spacing: .space12) {
            if position == .left {
                checkboxView(configuration: configuration)
            }

            configuration.label
            
            if position == .right {
                checkboxView(configuration: configuration)
            }
        }
        .onTapGesture { configuration.isOn.toggle() }
    }
    
    private func checkboxView(configuration: Configuration) -> some View {
        Group {
            switch configuration.isOn {
            case true: Images.System.checkmarkCircle.resizable().bold()
            case false: Images.System.circle.resizable()
            }
        }
            .frame(width: .image.small, height: .image.small)
            .foregroundColor(configuration.isOn ? Colors.blue : Colors.gray)
    }
}
