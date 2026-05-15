//
//  ViewController.swift
//  card
//
//  Created by Семён on 03.03.2026.
//  Copyright © 2026 Семён. All rights reserved.
//

import Cocoa

let bot1 = Bot("bot1")
let bot2 = Bot("bot2")
let bot3 = Bot("bot3")
var MovesBool: [Bool] = [true, false, false, false]

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var players: [String] = ["Player", "Bot1", "Bot2", "Bot3"]
    var playersMove: [String] = ["", "", "", ""]
    var hand_of_cards: [String] = []
    var selected_cards: [String] = []

    @IBOutlet weak var PlayersTable: NSTableView!
    @IBOutlet weak var PlayersMoveTable: NSTableView!
    @IBOutlet weak var Move: NSTextField!
    @IBOutlet weak var CardTable: NSTableView!
    @IBOutlet weak var SelectedCardTable: NSTableView!
    @IBOutlet weak var CardOnTable: NSTextField!
    @IBAction func StartButton(_ sender: Any) {
        let card = Card()
        hand_of_cards.removeAll()
        selected_cards.removeAll()
        SelectedCardTable.reloadData()
        
        for _ in 0...12 {
            hand_of_cards.append(card.out())
            bot1.BotDeck.append(card.out())
            bot2.BotDeck.append(card.out())
            bot3.BotDeck.append(card.out())
        }
        
        CardTable.reloadData()
    }
    @IBAction func SelectCard(_ sender: Any) {
        if MovesBool[0] {
            let row = CardTable.selectedRow
            
            if selected_cards.isEmpty {
                selected_cards.append(hand_of_cards[row])
                SelectedCardTable.reloadData()
            }else {
                if !comparison(row, hand_of_cards, selected_cards) ||
                    !comparsionRank(row, hand_of_cards, selected_cards){
                    SelectedCardTable.reloadData()
                } else {
                    selected_cards.append(hand_of_cards[row])
                    SelectedCardTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func CardOnTableButton(_ sender: Any) {
        if !selected_cards.isEmpty{
        var c = ""
        
        for i in 0..<selected_cards.count {
            c = "\(c) \(selected_cards[i])"
        }
        
        var exam = true
        
        if CardOnTable.stringValue != "Пас" &&
            CardOnTable.stringValue != "" &&
        c != "" {exam = bot1.playerBool(CardOnTable.stringValue, c)}
        
            if exam {
                if MovesBool[0]{
                    
                    CardOnTable.stringValue = ""
                    
                    hand_of_cards = hand_of_cards.filter { !selected_cards.contains($0) }
                    
                    selected_cards.removeAll()
                    
                    CardTable.reloadData()
                    SelectedCardTable.reloadData()
                    
                    CardOnTable.stringValue = c
                    
                    if DeckEmpty(hand_of_cards) {
                        endgame("Игрок")
                        hand_of_cards.removeAll()
                        selected_cards.removeAll()
                        CardTable.reloadData()
                        SelectedCardTable.reloadData()
                        return
                    }
                    
                    MovesBool[0] = false
                    MovesBool[1] = true
                    Moves()
                    
                    counting = 0
                    botInGame(c)}}
        }
    }
    
    var counting = 0
    
    func countexam(_ text: String) -> Bool {
        if text == "Пас" ||
            text == "" {
            counting = counting + 1
            return true
        }
        counting = 0
        return false
    }
    
    func botInGame(_ c: String){
        let bact1 = bot1.actions(c)
        let bact2 = bot2.actions(bact1)
        let bact3 = bot3.actions(bact2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.CardOnTable.stringValue = bact1
            if bot1.DeckEmpty() {
                self.endgame("Bot1")
                self.hand_of_cards.removeAll()
                self.selected_cards.removeAll()
                self.CardTable.reloadData()
                self.SelectedCardTable.reloadData()
                return
            }
            MovesBool[2] = true
            MovesBool[1] = false
            self.Moves()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.CardOnTable.stringValue = bact2
            if bot2.DeckEmpty() {
                self.endgame("Bot2")
                self.hand_of_cards.removeAll()
                self.selected_cards.removeAll()
                self.CardTable.reloadData()
                self.SelectedCardTable.reloadData()
                return
            }
            MovesBool[3] = true
            MovesBool[2] = false
            self.Moves()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.CardOnTable.stringValue = bact3
            if bot3.DeckEmpty() {
                self.endgame("Bot3")
                self.hand_of_cards.removeAll()
                self.selected_cards.removeAll()
                self.CardTable.reloadData()
                self.SelectedCardTable.reloadData()
                return
            }
            MovesBool[0] = true
            MovesBool[3] = false
            self.Moves()
        }
    }
    
    @IBAction func CancellButton(_ sender: Any) {
        selected_cards.removeAll()
        SelectedCardTable.reloadData()
    }
    
    @IBAction func PassButton(_ sender: Any) {
        CardOnTable.stringValue = "Пас"
        if MovesBool[0] {
            MovesBool[0] = false
            MovesBool[1] = true
            Moves()
            
            counting = counting + 1
            
            botInGame("")}
    }
    var cc = ""
    
    func endgame(_ name: String){
        CardOnTable.stringValue = "\(name) победил"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Moves()
        
        CardTable.dataSource = self
        CardTable.delegate = self
        
        SelectedCardTable.dataSource = self
        SelectedCardTable.delegate = self
        
        PlayersTable.dataSource = self
        PlayersTable.delegate = self
        
        PlayersMoveTable.dataSource = self
        PlayersMoveTable.delegate = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == CardTable {
            return hand_of_cards.count
        } else if tableView == SelectedCardTable {
            return selected_cards.count
        } else if tableView == PlayersTable {
            return players.count
        } else if tableView == PlayersMoveTable {
            return playersMove.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier else { return nil }
        
        if let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView {
            
            if tableView == CardTable {
                cell.textField?.stringValue = hand_of_cards[row]
            } else if tableView == SelectedCardTable {
                cell.textField?.stringValue = selected_cards[row]
            } else if tableView == PlayersTable {
                cell.textField?.stringValue = players[row]
            } else if tableView == PlayersMoveTable {
                cell.textField?.stringValue = playersMove[row]
            }
            
            return cell
        }
        
        return nil
    }
    
    func Moves() {
        if MovesBool[0] {
            playersMove[0] = "Ход"
            playersMove[1] = ""
            playersMove[2] = ""
            playersMove[3] = ""
            PlayersMoveTable.reloadData()
        }
        if MovesBool[1] {
            playersMove[0] = ""
            playersMove[1] = "Ход"
            playersMove[2] = ""
            playersMove[3] = ""
            PlayersMoveTable.reloadData()
        }
        if MovesBool[2] {
            playersMove[0] = ""
            playersMove[1] = ""
            playersMove[2] = "Ход"
            playersMove[3] = ""
            PlayersMoveTable.reloadData()
        }
        if MovesBool[3] {
            playersMove[0] = ""
            playersMove[1] = ""
            playersMove[2] = ""
            playersMove[3] = "Ход"
            PlayersMoveTable.reloadData()
        }
    }
    
}
