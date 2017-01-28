//
//  ListController.swift
//  Rfactor
//
//  Created by Derr McDuff on 17-01-21.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class ListController: UITableViewController {
    
    var passedNoteList:[Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        passedNoteList = instancedData.notes
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedNoteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        //cell.textLabel = passedNoteList[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNote" {
            if let indexOfNote = self.tableView.indexPathForSelectedRow?.row {
                let controller = (segue.destination as! UINavigationController).topViewController as! NoteController
                controller.index = indexOfNote
            }
        }
    }
    
    
    
}
