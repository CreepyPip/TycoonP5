    //
    //  Bot.swift
    //  card
    //
    //  Created by Семён on 23.03.2026.
    //  Copyright © 2026 Семён. All rights reserved.
    //

    import Foundation

    class Bot {
        
        var name = ""
        public var BotDeck: [String] = []
        
        init(_ name: String) {
            self.name = name
        }
        
        func DeckEmpty() -> Bool {
            if BotDeck.count == 0 {return true}
            else if BotDeck.count == 1 ||
                        BotDeck.count == 2 {
                for i in 0..<BotDeck.count {
                    if BotDeck[i] != "JokerB" &&
                        BotDeck[i] != "JokerW" {
                        return false
                    }
                }
                return true
                }
            return false
        }
        
        func actions(_ cards: String) -> String {
            if cards == "" || cards == "Пас" {
                return playRandomCards()
            }
            return respondToPlayer(cards)
        }
        
        private func playRandomCards() -> String {
            guard !BotDeck.isEmpty else { return "Пас" }
            
            var rankGroups: [String: [String]] = [:]
            var jokers: [String] = []
            
            for card in BotDeck {
                if isJoker(card) { jokers.append(card) }
                else if let r = getRank(from: card) { rankGroups[r, default: []].append(card) }
            }
            
            guard let chosenRank = rankGroups.keys.randomElement() else {
                let count = min(4, jokers.count)
                let picked = jokers.prefix(count)
                removeCards(from: &BotDeck, Array(picked))
                return picked.joined(separator: " ")
            }
            
            let maxFromRank = min(rankGroups[chosenRank]!.count, 4)
            let countFromRank = Int.random(in: 1...maxFromRank)
            
            var result: [String] = []
            result.append(contentsOf: rankGroups[chosenRank]!.prefix(countFromRank))
            
            let remainingSlots = 4 - result.count
            if remainingSlots > 0 && !jokers.isEmpty {
                let jokersToAdd = Int.random(in: 0...min(jokers.count, remainingSlots))
                result.append(contentsOf: jokers.prefix(jokersToAdd))
            }
            
            removeCards(from: &BotDeck, result)
            return result.joined(separator: " ")
        }
        
        
        private func respondToPlayer(_ playerCards: String) -> String {
            let playerList = playerCards.components(separatedBy: " ").filter { !$0.isEmpty }
            guard let targetRank = getRank(from: playerList.first ?? "") else { return "Пас" }
            
            let playerCount = playerList.count
            guard playerCount >= 1 && playerCount <= 4 else { return "Пас" }
            
            var rankGroups: [String: [String]] = [:]
            var jokers: [String] = []
            for card in BotDeck {
                if isJoker(card) { jokers.append(card) }
                else if let r = getRank(from: card) { rankGroups[r, default: []].append(card) }
            }
            
            let validRanks = rankGroups.filter { allowedCards($0.key, targetRank) }
                .keys.sorted { (getWeight($0) ?? 0) > (getWeight($1) ?? 0) }
            
            guard !validRanks.isEmpty else { return "Пас" }
            
            for rank in validRanks {
                var candidates = rankGroups[rank] ?? []
                var result: [String] = []
                
                guard let first = candidates.first else { continue }
                result.append(first)
                candidates.removeFirst()
                
                let sameRankNeeded = playerCount - result.count
                let sameRankAvailable = min(candidates.count, sameRankNeeded)
                result.append(contentsOf: candidates.prefix(sameRankAvailable))
                
                
                
                let jokersNeeded = playerCount - result.count
                if jokersNeeded > 0 && jokers.count >= jokersNeeded {
                    result.append(contentsOf: jokers.prefix(jokersNeeded))
                }
                
                
                if result.count == playerCount {
                    removeCards(from: &BotDeck, result)
                    return result.joined(separator: " ")
                }
                result.removeAll()
            }
            
            return "Пас"
        }
        
        private func removeCards(from deck: inout [String], _ cards: [String]) {
            for card in cards {
                if let idx = deck.firstIndex(of: card) {
                    deck.remove(at: idx)
                }
            }
        }
        
        private func getRank(from card: String) -> String? {
            let suits = "♠♥♦♣"
            if let range = card.rangeOfCharacter(from: CharacterSet(charactersIn: suits)) {
                return String(card[..<range.lowerBound])
            }
            return card.contains("Joker") ? "Joker" : nil
        }
        
        private func isJoker(_ card: String) -> Bool {
            return card.contains("Joker")
        }
        
        private func getWeight(_ text: String) -> Int {
            let rank = text.replacingOccurrences(of: " ", with: "")
            let weights: [String: Int] = [
                "2": 16, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10,
                "J": 11, "Q": 12, "K": 13, "A": 14, "Joker": 15
            ]
            return weights[rank] ?? 0
        }
        
        private func allowedCards(_ rank1: String, _ rank2: String) -> Bool {
            
            let w1 = getWeight(rank1)
            let w2 = getWeight(rank2)
            return w1 > w2 || (w1 == 3 && w2 == 16)
        }
        
        func playerBool(_ bottext: String,_ playertext: String) -> Bool {
            let suit = "♠♥♦♣"
            
            let botList = bottext.components(separatedBy: " ").filter { !$0.isEmpty }
            let botCount = botList.count
            
            let playerList = playertext.components(separatedBy: " ").filter { !$0.isEmpty }
            let playerCount = playerList.count
            
            let rankbotindex = bottext.firstIndex(where: { suit.contains($0) })
            let rankplayerindex = playertext.firstIndex(where: { suit.contains($0) })
            
            let rankbot = String((bottext[bottext.startIndex..<rankbotindex!]))
            let rankplayer = String((playertext[playertext.startIndex..<rankplayerindex!]))

            let booboo = allowedCards(rankplayer, rankbot)
            
            if booboo && botCount == playerCount {return true}
            else {return false}
            
        }
    }
