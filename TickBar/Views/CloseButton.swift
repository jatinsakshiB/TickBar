//
//  CloseButton.swift
//  TickBar
//
//  Created by Jatin Batra on 19/08/25.
//

import SwiftUI

struct CloseButton: View {
    /// Action to perform on click
    var action: () -> Void
    
    @State private var isHovering = false

    private let diameter: CGFloat = 12
    private let xmarkSize: CGFloat = 6
    /// Fine‑tune to perfectly center the xmark (SF Symbols sits a hair low by default)
    private let xmarkYOffset: CGFloat = -0.3

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color(red: 1.0, green: 0.27, blue: 0.23)) // Apple close red
                .frame(width: diameter, height: diameter)
                .overlay(alignment: .center) {
                    Image(systemName: "xmark")
                        .font(.system(size: xmarkSize, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(isHovering ? 1 : 0) // show only on hover
                        .offset(y: xmarkYOffset)      // alignment tweak
                        .allowsHitTesting(false)      // keep hover/click on the circle
                }
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
        .onHover { inside in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = inside
            }
        }
        .help("Close")
        .accessibilityLabel(Text("Close"))
    }
}

#Preview {
    CloseButton{
        
    }.padding()
}
