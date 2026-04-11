//
//  Bot.swift
//  card
//
//  Created by Семён on 23.03.2026.
//  Copyright © 2026 Семён. All rights reserved.
//

import Foundation

class Bot{
    
    var name = ""
    public var BotDeck: [String] = []
    
    init(_ name: String) {
        self.name = ""
    }
    
    func actions(_ cards: String) -> String {
        let ranks = "(10|[2-9]|J|Q|K|A|Joker)"
        let pattern = "\(ranks)"
        
        
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(cards.startIndex..., in: cards)
            
            let matches = regex.matches(in: cards, options: [], range: range)
            
            return BotAction(cards, Int(matches.count))
        }
        
        return "res"
    }
    
    private func BotAction (_ cards: String,_ num: Int) -> String {
        
        let suit = "♠♥♦♣"
        let ranks = regex("(10|[2-9]|J|Q|K|A)")
        let jokers = regex("Joker")
        var c = ""
        var j = 0
        
        let rankindex = cards.firstIndex(where: { suit.contains($0) })!
        let a = String(cards[cards.startIndex..<rankindex])
        var firstcard = "0"
        var curcard = ""
        var cardindex = curcard.startIndex
        
        for i in 0...num-1 {
            if i != 0 {
                var randcard = "\(BotDeck.randomElement()!)"
                if !jokers.matches(randcard){
                cardindex = randcard.firstIndex(where: { suit.contains($0) })!
                curcard = (String(randcard[randcard.startIndex..<cardindex]))
                while (curcard != firstcard) ||
                    jokers.matches(randcard) ||
                    (j == 13) {
                    randcard = "\(BotDeck.randomElement()!)"
                        if jokers.matches(randcard){break}
                    cardindex = randcard.firstIndex(where: { suit.contains($0) })!
                    curcard = (String(randcard[randcard.startIndex..<cardindex]))
                        j = j + 1
                    }}
                c = "\(c) \(randcard)"
            } else {
                while !(allowedCards(a, firstcard)) || (j == 13){
                    c = "\(BotDeck.randomElement()!)"
                    while jokers.matches(c) {
                        cardindex = c.firstIndex(where: { suit.contains($0) })!
                        firstcard = (String(c[c.startIndex..<cardindex]))
                    }
                j = j + 1
                }
            }
        }
        
        return c
    }
    
    private func allowedCards (_ rank1: String,_ rank2: String) -> Bool {
        
        var weights: [String: Int] = [
            "J": 11, "Q": 12, "K": 13, "A": 14
        ]
        
        for i in 2...10 {
            weights[String(i)] = i
        }
        
        let weight1 = weights[rank1] ?? 0
        let weight2 = weights[rank2] ?? 0
        
        if (weight1 < weight2) && !(weight1 == 2) {return true}
        else if (weight1 == 2) && (weight2 == 3) {return true}
        return false
    }
}


