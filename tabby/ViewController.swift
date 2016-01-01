//
//  ViewController.swift
//  tabby
//
//  Created by Gale on 12/28/15.
//  Copyright © 2015 Gale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        
        // Making the keyboard appear upon opening the app
        billField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChange(sender: AnyObject) {
        let tipPercentages = [0.18, 0.2, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
                
        let billAmount = NSString(string: billField.text!).doubleValue
        
        let tip = billAmount * tipPercentage
        let total = tip + billAmount
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }

    @IBAction func onTap(sender: AnyObject) {
        // Making the keyboard disappear only after having added text to the text field
        let bill = NSString(string: billField.text!)
        if bill.length >= 1 {
            view.endEditing(true)
        }
    }
}

