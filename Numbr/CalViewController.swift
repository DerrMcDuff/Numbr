//
//  File.swift
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
        
        if (indexPath.row%2 == 1) {cell.backgroundColor=#colorLiteral(red: 0.2467072606, green: 0.2543253303, blue: 0.2875217199, alpha: 1)} else {cell.backgroundColor=#colorLiteral(red: 0.3363534081, green: 0.3396836398, blue: 0.3396836398, alpha: 1)}
        cell.lineContent.delegate = self
        return cell
    }
    @IBAction func reloadData(_ sender: UITextField) {
        reloadDataAlgo(sender, "noTap")
    }
    
    @IBAction func reloadDataTap(_ sender: UITextField) {
        reloadDataAlgo(sender, "tap")
    }
    
    func reloadDataAlgo(_ sender: UITextField, _ context: String) {
        let tar = sender.superview?.superview as? LineOfCode
        tar?.lineManaging()
        self.tableView.reloadData()
        
        // No need to change First Responder when tap
        if context == "noTap" {
            let ii:Int = tar!.indexProp+1
            print(ii)
            let i:IndexPath = IndexPath(row: ii, section: 0)
            (tableView.cellForRow(at: i) as! LineOfCode).lineContent.becomeFirstResponder()
        }
    }
    
    
}
