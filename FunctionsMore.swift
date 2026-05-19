//
//  FunctionsMore.swift
//  card
//
//  Created by Семён on 20.03.2026.
//  Copyright © 2026 Семён. All rights reserved.
//

import Foundation
// Возможность игрока выложить карты
func comparsionRank (_ row: Int, _ hand_of_cards: [String],_ selected_cards: [String]) -> Bool {
    let ranks = "♠♥♦♣"
    
    if hand_of_cards[row] == "JokerW" ||
        hand_of_cards[row] == "JokerB" {
        return true
    }
    
    let compnum = selected_cards[0]
    var rankindex = compnum.firstIndex(where: { ranks.contains($0) })
    let a = (compnum[compnum.startIndex..<rankindex!])
    
    let compnum2 = hand_of_cards[row]
    rankindex = compnum2.firstIndex(where: { ranks.contains($0) })
    let b = (compnum2[compnum2.startIndex..<rankindex!])
    
    if a == b {
        return true
    }
    return false
}

// Взял ли игрок карту
func comparison(_ row: Int, _ hand_of_cards: [String],_ selected_cards: [String]) -> Bool {
    for i in 0...selected_cards.count - 1 {
        if selected_cards[i] == hand_of_cards[row]{
            return false
        }
    }
    return true
}

// Проверка на пустую колоду игрока
func DeckEmpty(_ hand_of_cards: [String]) -> Bool {
    if hand_of_cards.count == 0 {return true}
    else if hand_of_cards.count == 1 ||
                hand_of_cards.count == 2 {
        for i in 0..<hand_of_cards.count {
            if hand_of_cards[i] != "JokerB" &&
                hand_of_cards[i] != "JokerW" {
                return false
            }
        }
        return true
        }
    return false
}
