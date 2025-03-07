//
//  CardBack.swift
//  memorygame
//
//  Created by Palamoni, Nikhil Palamoni on 3/6/25.
//
import SwiftUI

struct CardBack: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
            Stripes()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .aspectRatio(2/3, contentMode: .fit)
        .shadow(color: .black.opacity(0.4), radius: 4, x: 1, y: 5)
    }
}

struct Stripes: View {
    private let stripeWidth: CGFloat = 1
    private let stripeSpacing: CGFloat = 5
    
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let w = geo.size.width
                let h = geo.size.height
                stride(from: 0, to: w, by: stripeWidth + stripeSpacing).forEach { x in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: h))
                }
            }
            .stroke(Color.white.opacity(0.5), lineWidth: stripeWidth)
        }
    }
}

