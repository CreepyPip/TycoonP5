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
    
    @IBAction func CardOnTableButton(_ sender: Any) {
        
        CardOnTable.stringValue = ""
        
        var c = ""
        
        for i in 0...selected_cards.count - 1 {
            c = "\(c) \(selected_cards[i])"
        }

        hand_of_cards = hand_of_cards.filter { !selected_cards.contains($0) }
        
        selected_cards.removeAll()

        CardTable.reloadData()
        SelectedCardTable.reloadData()
        
        CardOnTable.stringValue = c
        
        MovesBool[0] = false
        MovesBool[1] = true
        Moves()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.CardOnTable.stringValue = bot1.actions(c)
            MovesBool[0] = true
            MovesBool[1] = false
            self.Moves()
        }
        
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
