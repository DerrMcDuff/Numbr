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
    let selectedColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 0.4650042808)
    @IBOutlet var aTableView: UITableView!
    var shortcutView:ShortcutsView!
    @IBOutlet var clavierView: ClavierView!
    
    override func viewDidLoad() {
        
        self.clavierView.initializeKeyboard()
        
        // Initialize controller Data
        passedNote = app.allData.notes[index]
        activeCell = passedNote.getIndex()
        
        // Delegation
        
        // TableView
        self.aTableView.delegate = self
        self.aTableView.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Put in-app input on top
        self.view.bringSubview(toFront: clavierView)
        
        // Notification for Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        
        // View handler
        
        aTableView.bounds.size.height = 225
        aTableView.layer.position.y = 390
        _ = setTableViewPosition()
        aTableView.scrollToRow(at: IndexPath(row:activeCell,section:0), at: UITableViewScrollPosition.top, animated: true)
        highlightLine(activeCell)
        
        
        shortcutView = ShortcutsView(CGFloat(290))
        view.addSubview(shortcutView)
        shortcutView.refreshShortcuts()
        self.view.bringSubview(toFront: shortcutView)
        super.viewDidLoad()
    }
    
    
    func setTableViewPosition()->Bool {
        
        if aTableView.layer.position.y > 180 && self.passedNote.getLinesCount()<7 {
            aTableView.layer.position.y = 400
            aTableView.layer.position.y = aTableView.layer.position.y - CGFloat(self.passedNote.getLinesCount() * (34))
        } else {
            aTableView.layer.position.y = 170
        }
        
        return true
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedNote.getLinesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "lineTableViewCell", for: indexPath) as! LineTableViewCell
        
        // Index
        cell.index.text = String(indexPath.row)
        cell.index.font = cell.index.font.withSize(15)
        cell.index.sizeToFit()
        cell.index.layer.position = CGPoint(x:10, y:17.5)
        cell.index.textColor = #colorLiteral(red: 0.839362018, green: 0.8453467832, blue: 0.8633010787, alpha: 1)
        
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
            var txt:String = " "
            txt.append(passedNote.getLine(at: indexPath.row).answer!.getText()!)
            cell.answer.text = txt
            
            cell.answer.center = cell.answer.originPos
            cell.answer.bounds.size = cell.answer.originSize
            cell.answer.bounds.size.height = 30
        }

        return cell
    }
    
    
    // Actions
    
    @IBAction func continuousEditing(_ sender: UITextField) {
        
        
        
        guard uptoDate else {
            
            let co = (aTableView.cellForRow(at: IndexPath(row:activeCell,section:0)) as! LineTableViewCell)
            if co.content.text != nil{
                
                let rowsToUpdate:[Int] = passedNote.updateFromLine(at: activeCell, with: co.content.text!)
                
                var rowPaths: [NSIndexPath] = []
                
                for i in rowsToUpdate {
                    rowPaths.append(NSIndexPath(row: i, section: 0))
                }
                
                aTableView.reloadRows(at: rowPaths as [IndexPath], with: .fade)
            }
            activeCell = Int((sender.superview?.superview as! LineTableViewCell).index.text!)!
            
            app.allData.notes[index] = self.passedNote
            app.allData.saveData()
            app.allData.loadData()
            shortcutView.refreshShortcuts()
            highlightLine(activeCell)
            return
        }
        
        uptoDate = false
        
    }
    
    @IBAction func switchLine(_ sender: UITextField) {
        
        uptoDate = true
        
        activeCell = Int((sender.superview?.superview as! LineTableViewCell).index.text!)!
        
        
        let rowsToUpdate:[Int] = app.allData.notes[index].updateFromLine(at: activeCell, with: sender.text!)
        
        passedNote = app.allData.notes[index]
        
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
            highlightLine((-1*(activeCell+1)))
        } else {
            aTableView.scrollToRow(at: IndexPath(row:activeCell, section:0), at: UITableViewScrollPosition.middle, animated: false)
            let newActiveCell = aTableView.cellForRow(at: IndexPath(row: activeCell+1, section: 0)) as! LineTableViewCell
            newActiveCell.content.becomeFirstResponder()
            
        }
        activeCell += 1
        app.allData.notes[index] = self.passedNote
        app.allData.saveData()
        app.allData.loadData()
        shortcutView.refreshShortcuts()
        highlightLine(activeCell)
    }
    
    // Selection handling
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        uptoDate = false
        if let ac = (aTableView.cellForRow(at: IndexPath(row:activeCell,section:0)) as? LineTableViewCell) {
            continuousEditing(ac.content)
        }
        
        activeCell = indexPath.row
        highlightLine(indexPath.row)
    }
    
    func highlightLine(_ r:Int) {
        aTableView.reloadData()
        
        if let cell = aTableView.cellForRow(at: IndexPath(row:r, section: 0)) as? LineTableViewCell {
            cell.index.layer.position = CGPoint(x:10,y:15)
            cell.index.textColor = selectedColor
            cell.index.font = cell.index.font.withSize(20)
            cell.index.sizeToFit()
        }
    }


    
    func keyboardWillShow(notification: NSNotification) {
        print("show")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            kbH = CGFloat(keyboardSize.height)
        }
        shortcutView.moveTo(.overKeyboard)
    
    }
    
    func keyboardWillHide(notification: NSNotification) {
        shortcutView.moveTo(.origin)
    }
    

}
