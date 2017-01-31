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
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var index: Int = 0
    var passedNote:Note = Note(at: 0)
    var uptoDate:Bool = false
    
    override func viewDidLoad() {
        passedNote = app.allData.notes[index]
        super.viewDidLoad()
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
            cell.answer.text = passedNote.getLine(at: indexPath.row).answer?.getText()
            cell.answer.center = cell.answer.originPos
            cell.answer.bounds.size = cell.answer.originSize
            cell.answer.bounds.size.height = 30
        }
        return cell
        
    }
    
    
    // Actions
    
    
    @IBAction func continuousEditing(_ sender: UITextField) {
        
        guard uptoDate else {
            
            let activeCell = Int((sender.superview?.superview as! LineTableViewCell).index.text!)
            
            let rowsToUpdate:[Int] = passedNote.updateFromLine(at: activeCell!, with: sender.text!)
            var rowPaths: [NSIndexPath] = []
            
            for i in rowsToUpdate {
                rowPaths.append(NSIndexPath(row: i, section: 0))
            }
            
            tableView.reloadRows(at: rowPaths as [IndexPath], with: .fade)
            
            return
        }
        uptoDate = false
        app.allData.saveData()
    }
    
    @IBAction func switchLine(_ sender: UITextField) {
        
        uptoDate = true
        
        let activeCell = Int((sender.superview?.superview as! LineTableViewCell).index.text!)
        
        
        
        let rowsToUpdate:[Int] = passedNote.updateFromLine(at: activeCell!, with: sender.text!)
        var rowPaths: [NSIndexPath] = []
        
        for i in rowsToUpdate {
            rowPaths.append(NSIndexPath(row: i, section: 0))
        }
        
        tableView.reloadRows(at: rowPaths as [IndexPath], with: .fade)
        if activeCell! == passedNote.getLinesCount()-1 {
            passedNote.addLine(at: passedNote.getLinesCount())
            tableView.reloadData()
        }
        
        if let newActiveCell = tableView.cellForRow(at: IndexPath(row:activeCell!+1, section: 0)) as? LineTableViewCell {
            newActiveCell.content.becomeFirstResponder()
        }
    }
    
}
