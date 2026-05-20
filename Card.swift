//
//  Card.swift
//  card
//
//  Created by Семён on 07.03.2026.
//  Copyright © 2026 Семён. All rights reserved.
//

import Foundation

class Card {
    var started = false
    var cards: [String] = []
    
    private var rank: [String] = ["2", "3", "4", "5", "6", "7", "8", "9", "10",
                               "J", "Q", "K", "A"]
    private var suit: [String] = ["♠", "♥", "♦", "♣"]
    private var jokers: [String] = ["B", "W"]
    
    func out() -> String {
        
        if !started {
            cards = deck()
        }
        
        let card = cards.randomElement()!
        
        if let index = cards.firstIndex(of: card) {
            cards.remove(at: index)
        }
        
        return card
    }
    
    // Создание колоды
    private func deck() -> [String] {
        var d: [String] = []
        
        for i in 0...12 {
            for j in 0...3 {
                d.append("\(rank[i])\(suit[j])")
            }
        }
        
        d.append("Joker\(jokers[0])")
        d.append("Joker\(jokers[1])")
        
        started = true
        
        return d
    }
    
}
