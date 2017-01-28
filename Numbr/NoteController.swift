//
//  Note.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class NoteController: UITableViewController, UITextFieldDelegate {
    
    var index: Int = 0
    var passedNote:Note = Note(at: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passedNote = instancedData.notes[index]
        tableView.delegate = self
    }
    
    
    
    // Creating the table
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedNote.getLinesCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LineTableViewCell {
        let cell:LineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "lineTableViewCell", for: indexPath) as! LineTableViewCell
        
        // Index
        cell.index.text = String(indexPath.row)
        cell.index.layer.position = CGPoint(x:10, y:22.5)
        
        // Content
        cell.content.text = passedNote.getLine(at: indexPath.row).content
        cell.content.bounds.size.height = 50
        cell.content.layer.position = CGPoint(x: cell.content.bounds.width/2+20, y:22.5)
        cell.content.delegate = self
        
        // Answer
        
        
        if passedNote.getLine(at: indexPath.row).answer == nil {
            cell.answer.isHidden = true
        } else {
            cell.answer.isHidden = false
            cell.answer.text = passedNote.getLine(at: indexPath.row).answer?.text
            cell.answer.center = cell.answer.originPos
            cell.answer.bounds.size = cell.answer.originSize
            cell.answer.bounds.size.height = 30
        }
        
        
        return cell
        
    }
    
    
    // Actions
    
    
    @IBAction func continuousEditing(_ sender: UITextField) {
        let activeCell = Int((sender.superview?.superview as! LineTableViewCell).index.text!)
        passedNote.getLine(at: activeCell!).setAnswer(with: sender.text!)
        tableView.reloadRows(at: [IndexPath(item: activeCell!, section: 0)], with: .none)
    }
    
    @IBAction func switchLine(_ sender: UITextField) {
        let activeCell = Int((sender.superview?.superview as! LineTableViewCell).index.text!)
        
        passedNote.getLine(at: activeCell!).setAnswer(with: sender.text!)
        
        tableView.reloadRows(at: [IndexPath(item: activeCell!, section: 0)], with: .none)
        
        if activeCell! == passedNote.getLinesCount()-1 {
            passedNote.addLine(at: passedNote.getLinesCount())
            tableView.reloadData()
            tableView.endUpdates()
        }
        
        if let newActiveCell = tableView.cellForRow(at: IndexPath(row:activeCell!+1, section: 0)) as? LineTableViewCell {
            newActiveCell.content.becomeFirstResponder()
        }
        
    }
    
}
