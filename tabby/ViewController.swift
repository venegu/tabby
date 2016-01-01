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
        
        // Initial currency formatting when app starts
        let currencySymbol = NSLocale.currentLocale().objectForKey(NSLocaleCurrencySymbol) as! String
        billField.placeholder = (currencySymbol as String) + "0.00"
        tipLabel.text = (currencySymbol as String) + "0.00"
        totalLabel.text =  (currencySymbol as String) + "0.00"
        
        //Setting previous bill amount when the app closed after checking that billDate returns valid values and comparing the times
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if(defaults.objectForKey("billDate") != nil && NSDate.init().timeIntervalSinceDate(defaults.objectForKey("billDate") as! NSDate) < 600) {
            let oldAmount = defaults.objectForKey("billAmount")
            billField.text = (oldAmount as! String)
        }
        
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
        
        // Currency formatting after inputting a value
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
        
        //Storing bill amount
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(billField.text, forKey:"billAmount")
        defaults.setObject(NSDate.init(), forKey: "billDate")
        defaults.synchronize()
    }

    @IBAction func onTap(sender: AnyObject) {
        // Making the keyboard disappear only after having added text to the text field
        let bill = NSString(string: billField.text!)
        if bill.length >= 1 {
            view.endEditing(true)
        }
    }
}

