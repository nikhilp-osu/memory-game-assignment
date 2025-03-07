//
//  CardGameViewModel.swift
//  memorygame
//
//  Created by Palamoni, Nikhil Palamoni on 3/6/25.
//  ["❤️","😂","🙈","🎶","☠️","🐷"]
import SwiftUI

class CardGameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var score = 0
    @Published var moves = 0
    @Published var gameOver = false
    
    private var storedIndex: Int?

    init() {
        startNewGame()
    }
    
    func startNewGame() {
        let emojis = ["❤️","😂","🙈","🎶","☠️","🐷"]
        cards = emojis.flatMap { [Card(emoji: $0), Card(emoji: $0)] }
        score = 0
        moves = 0
        gameOver = false
        storedIndex = nil
        shuffleCards()
    }
    
    func shuffleCards() {
        for i in cards.indices {
            if !cards[i].isMatched {
                cards[i].isFaceUp = false
            }
        }
        // Clear any stored selection
        storedIndex = nil
        cards.shuffle()
    }
    
    func selectCard(_ card: Card) {
        guard let idx = cards.firstIndex(where: { $0.id == card.id }),
              !cards[idx].isMatched,
              !cards[idx].isFaceUp else { return }
        
        if let firstIdx = storedIndex {
            moves += 1
            cards[idx].isFaceUp = true
            
            if cards[idx].emoji == cards[firstIdx].emoji {
                cards[idx].isMatched = true
                cards[firstIdx].isMatched = true
                score += 2
                if cards.allSatisfy({ $0.isMatched }) {
                    gameOver = true
                }
            } else {
                if score > 0 { score -= 1 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    self.cards[idx].isFaceUp = false
                    self.cards[firstIdx].isFaceUp = false
                }
            }
            storedIndex = nil
        } else {
            cards.indices
                .filter { !cards[$0].isMatched }
                .forEach { cards[$0].isFaceUp = false }
            storedIndex = idx
            cards[idx].isFaceUp = true
        }
    }
}
