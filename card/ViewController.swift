//
//  ViewController.swift
//  card
//
//  Created by Семён on 03.03.2026.
//  Copyright © 2026 Семён. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var hand_of_cards: [String] = []
    var selected_cards: [String] = []
    

    @IBOutlet weak var CardTable: NSTableView!
    @IBOutlet weak var SelectedCardTable: NSTableView!
    @IBAction func StartButton(_ sender: Any) {
        let card = Card()
        hand_of_cards.removeAll()
        
        for _ in 0...12 {
            hand_of_cards.append(card.out())
        }
        
        CardTable.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CardTable.dataSource = self
        CardTable.delegate = self
        
        SelectedCardTable.dataSource = self
        SelectedCardTable.delegate = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == CardTable {
            return hand_of_cards.count
        } else if tableView == SelectedCardTable {
            return selected_cards.count
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
            }
            
            return cell
        }
        
        return nil
    }
    

}
