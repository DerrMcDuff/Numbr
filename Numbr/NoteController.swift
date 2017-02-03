//
//  Note.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class NoteController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var activeCell:Int = 0
    let app = UIApplication.shared.delegate as! AppDelegate
    var index: Int = 0
    var passedNote:Note = Note(at: 0)
    var uptoDate:Bool = false
    
    
    @IBOutlet var clavierView: UIView!
    @IBOutlet var aTableView: UITableView!
    
    @IBOutlet var shortcuts: [UIButton]!
    
    
    override func viewDidLoad() {
        
        passedNote = app.allData.notes[index]
        activeCell = passedNote.getIndex()
        self.aTableView.delegate = self
        self.aTableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        super.viewDidLoad()
        self.view.bringSubview(toFront: clavierView)
        _ = self.updateVariables()
        aTableView.bounds.size.height = 225
        aTableView.layer.position.y = 400
        _ = setTableViewPosition()
        aTableView.scrollToRow(at: IndexPath(row:activeCell,section:0), at: UITableViewScrollPosition.top, animated: true)
        print("damn")
    }
    
    func setTableViewPosition()->Bool {
        
        if aTableView.layer.position.y > 180 && self.passedNote.getLinesCount()<7 {
            aTableView.layer.position.y = 400
            aTableView.layer.position.y = aTableView.layer.position.y - CGFloat(self.passedNote.getLinesCount() * (34))
        } else {
            aTableView.layer.position.y = 175
        }
        
        return true
    }

    
    func updateVariables() -> Bool {
        
        var i:Int = 0
        
        for v in app.allData.varDictio.sorted(by: { $0.0 < $1.0 }) {
            if i < shortcuts.count {
                shortcuts[i].titleLabel?.text = v.key
                print("notelse")
            } else {
                return true
            }
            i += 1
        }
        return true
    }
    
    
    
    
    
    
    // Creating the table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedNote.getLinesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "lineTableViewCell", for: indexPath) as! LineTableViewCell
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Index
        cell.index.text = String(indexPath.row)
        cell.index.layer.position = CGPoint(x:10, y:17.5)
        
        // Content
        cell.content.text = passedNote.getLine(at: indexPath.row).content
        cell.content.bounds.size.height = 32
        cell.content.layer.position = CGPoint(x: cell.content.bounds.width/2+20, y:17.5)
        cell.content.delegate = self
        cell.content.isUserInteractionEnabled = false
        
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
            
            activeCell = Int((sender.superview?.superview as! LineTableViewCell).index.text!)!
            
            let rowsToUpdate:[Int] = passedNote.updateFromLine(at: activeCell, with: sender.text!)
            var rowPaths: [NSIndexPath] = []
            
            for i in rowsToUpdate {
                rowPaths.append(NSIndexPath(row: i, section: 0))
            }
            
            aTableView.reloadRows(at: rowPaths as [IndexPath], with: .fade)
            
            app.allData.saveData()
            passedNote = app.allData.notes[index]
            activeCell = passedNote.getIndex()
            
//            _ = updateVariables()
            
            return
        }
        
        uptoDate = false
        
    }
    
    @IBAction func switchLine(_ sender: UITextField) {
        
        uptoDate = true
        
        activeCell = Int((sender.superview?.superview as! LineTableViewCell).index.text!)!
        
        
        let rowsToUpdate:[Int] = passedNote.updateFromLine(at: activeCell, with: sender.text!)
        var rowPaths: [NSIndexPath] = []
        
        for i in rowsToUpdate {
            rowPaths.append(NSIndexPath(row: i, section: 0))
        }
        
        aTableView.reloadRows(at: rowPaths as [IndexPath], with: .fade)
        
        if activeCell == passedNote.getLinesCount()-1 {
            passedNote.addLine(at: passedNote.getLinesCount())
            aTableView.reloadData()
        }
        _ = setTableViewPosition()
        if let newActiveCell = aTableView.cellForRow(at: IndexPath(row: activeCell+1, section: 0)) as? LineTableViewCell {
            newActiveCell.content.becomeFirstResponder()
            aTableView.cellForRow(at: IndexPath(row:activeCell,section:0))!.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            aTableView.cellForRow(at: IndexPath(row:activeCell+1,section:0))!.backgroundColor = #colorLiteral(red: 0.2387202274, green: 0.986285238, blue: 1, alpha: 0.1540560788)
        } else {
            aTableView.scrollToRow(at: IndexPath(row:activeCell, section:0), at: UITableViewScrollPosition.top, animated: false)
            let newActiveCell = aTableView.cellForRow(at: IndexPath(row: activeCell+1, section: 0)) as! LineTableViewCell
            newActiveCell.content.becomeFirstResponder()
        }
        activeCell += 1
        
        app.allData.notes[index] = self.passedNote
        app.allData.saveData()
        app.allData.loadData()
        _ = updateVariables()
    }
    
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = updateVariables()
        textField.isUserInteractionEnabled = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        uptoDate = false
        aTableView.cellForRow(at: indexPath)!.backgroundColor = #colorLiteral(red: 0.2387202274, green: 0.986285238, blue: 1, alpha: 0.1540560788)
        continuousEditing((aTableView.cellForRow(at: IndexPath(row:activeCell,section:0)) as! LineTableViewCell).content)
        activeCell = indexPath.row

    }
    
}
