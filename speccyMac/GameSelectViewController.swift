//
//  GameSelectViewController.swift
//  speccyMac
//
//  Created by John Ward on 18/08/2017.
//  Copyright © 2017 John Ward. All rights reserved.
//

import Cocoa

class GameSelectViewController: NSViewController {
    
    weak var machine: Machine!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension GameSelectViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return machine.allGames.count
    }
}

extension GameSelectViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let game = machine.allGames[row]
        let tf = NSTextField(labelWithString: game.name)        
        return tf
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        if let tv = notification.object as? NSTableView {
            let selectedGame = machine.allGames[tv.selectedRow]
            machine.loadGame(selectedGame.file)
            
            self.dismissViewController(self)
        }
    }
}
