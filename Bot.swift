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
        let ranks = "(10|[2-9]|J|Q|K|A)"
        let jokers = regex("(Joker)")
        var c = ""
        
        var rankindex = cards.firstIndex(where: { suit.contains($0) })!
        let a = (cards[cards.startIndex..<rankindex])
        var firstcard = ""
        var curcard = ""
        var cardindex = curcard.startIndex
        
        for i in 0...num-1 {
            if i != 0 {
                var randcard = "\(BotDeck.randomElement()!)"
                if jokers.matches(randcard){
                cardindex = randcard.firstIndex(where: { suit.contains($0) })!
                curcard = (String(randcard[randcard.startIndex..<cardindex]))
                while (curcard != firstcard) ||
                    jokers.matches(randcard) {
                    randcard = "\(BotDeck.randomElement()!)"
                    cardindex = randcard.firstIndex(where: { suit.contains($0) })!
                    curcard = (String(randcard[randcard.startIndex..<cardindex]))
                    }}
                c = "\(c) \(randcard)"
            } else{
                c = "\(BotDeck.randomElement()!)"
                cardindex = c.firstIndex(where: { suit.contains($0) })!
                firstcard = (String(c[c.startIndex..<cardindex]))
            }
        }
        
        return c
    }
}


