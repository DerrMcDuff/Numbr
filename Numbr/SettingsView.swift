//
//  SettingsView.swift
//  Numbr
//
//  Created by Derr McDuff on 17-01-07.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    
    
    
    @IBOutlet var themePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themePicker.delegate = self
        themePicker.dataSource = self
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.dataTheme.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data.dataTheme[row]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let selectedIndex = themePicker.selectedRow(inComponent: 0)
        data.dataThemeOn = data.dataTheme[selectedIndex]
    }
}
