//
//  CardView.swift
//  memorygame
//
//  Created by Palamoni, Nikhil Palamoni on 3/6/25.
//
import SwiftUI

struct CardView: View {
    @ObservedObject var gameViewModel: CardGameViewModel
    let card: Card
    
    @State private var dragOffset = CGSize.zero
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                CardFront(card: card).opacity(card.isMatched ? 0.5 : 1)
            } else {
                CardBack().opacity(card.isMatched ? 0.5 : 1)
            }
        }
        .rotation3DEffect(.degrees(card.isFaceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
        .rotationEffect(.degrees(rotationAngle))
        .offset(dragOffset)
        .gesture(
            TapGesture(count: 2).onEnded {
                withAnimation(.linear(duration: 0.3)) {
                    rotationAngle += 180
                }
                withAnimation(.linear(duration: 0.6).delay(0.3)) {
                    rotationAngle -= 540
                }
                gameViewModel.selectCard(card)
            }
        )
        .gesture(
            DragGesture().onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { _ in
                withAnimation { dragOffset = .zero }
            }
        )
        .gesture(
            RotationGesture().onChanged { angle in
                rotationAngle = angle.degrees
            }
            .onEnded { _ in
                withAnimation { rotationAngle = 0 }
            }
        )
        .animation(.spring(), value: card.isFaceUp)
    }
}
