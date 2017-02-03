//
//  ListController.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class ListController: UITableViewController,UITextFieldDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var passedNoteList:[Note] = [Note(at:0)]
    @IBOutlet var addNewNote: UIBarButtonItem!
    
    @IBOutlet var clear: UIButton!
    
    @IBAction func clearUser(_ sender: UIButton) {
        
        UserDefaults.standard.removeObject(forKey: "varDictio")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        if app.allData.notes.isEmpty {
            app.allData.notes.append(Note(at:0))
        }
        
        passedNoteList = app.allData.notes
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedNoteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> NoteTableViewCell {
        let cell:NoteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as! NoteTableViewCell
        
        cell.NoteTitle.text = "NewNote"
        cell.NoteTitle.delegate = self
        return cell as NoteTableViewCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        app.allData.saveData()
        if segue.identifier == "showNote" {
            if let indexOfNote = self.tableView.indexPathForSelectedRow?.row {
                let controller = (segue.destination as! UINavigationController).topViewController as! NoteController
                controller.index = app.allData.notes.count-indexOfNote-1
            }
        }
    }
    
    @IBAction func add(_ sender: UIButton) {
        app.allData.notes.append(Note(at: app.allData.notes.count))
        passedNoteList.append(Note(at: passedNoteList.count))
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        
        app.allData.saveData()
        app.allData.loadData()
        passedNoteList = app.allData.notes
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            app.allData.notes.remove(at: app.allData.notes.count-indexPath.row-1)
            passedNoteList.remove(at:passedNoteList.count-indexPath.row-1)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            app.allData.saveData()
            passedNoteList = app.allData.notes
        }
    }
    
    
    
    
}
