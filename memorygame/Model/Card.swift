//
//  Card.swift
//  memorygame
//
//  Created by Palamoni, Nikhil Palamoni on 3/6/25.
//
import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let emoji: String
    var isFaceUp = false
    var isMatched = false
    var position: CGFloat = 0
}

