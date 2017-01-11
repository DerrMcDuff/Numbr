//
//  CalViewController.swift
//  Numbr
//
//  Created by Derr McDuff on 16-12-29.
//  Copyright © 2016 anonymous. All rights reserved.
//

import Foundation
import UIKit

class CalViewController: UITableViewController, UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.nowBlock.getNumberOfLines()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LineOfCode {
        let cell:LineOfCode = tableView.dequeueReusableCell(withIdentifier: "calCell", for: indexPath) as! LineOfCode
        cell.lineIndex.text = String(indexPath.row)
        cell.indexProp = Int(indexPath.row)
        cell.lineAns.text = data.nowBlock.getLineAns(at: indexPath.row)
        cell.lineAns.sizeToFit()
        cell.lineContent.text = data.nowBlock.getLineCon(at: indexPath.row)
        
        // Set Theme
        let t = data.dataThemeOn
        let n = (data.themeDictio[t]?.count)!
        for i in 1...n {
            if ((indexPath.row+1)%i == 0) {
                cell.backgroundColor = data.themeDictio[t]?[i-1]
            }
        }
        cell.lineContent.delegate = self
        return cell
    }
    
    @IBAction func reloadData(_ sender: UITextField) {
        let tar = sender.superview?.superview as! LineOfCode
        let didAdd:Bool = tar.lineManaging()
        self.tableView.reloadData()
        let ii:Int = tar.indexProp+1
        let i:IndexPath = IndexPath(row: ii, section: 0)
        let a = (tableView.cellForRow(at: i) as? LineOfCode)
        if a != nil {
            a?.lineContent.becomeFirstResponder()
        } else {
            if (!didAdd) {
                tableView.scrollToRow(at: IndexPath(row: tar.indexProp-3, section: 0), at: UITableViewScrollPosition.top, animated: false)
            } else {
                tableView.scrollToRow(at: IndexPath(row: tar.indexProp, section: 0), at: UITableViewScrollPosition.top, animated: false)
            }
            let b = (tableView.cellForRow(at: i) as? LineOfCode)
            b?.lineContent.becomeFirstResponder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
}
