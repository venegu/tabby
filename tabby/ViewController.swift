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
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var numberPeopleLabel: UILabel!
    @IBOutlet weak var tipPerPersonLabel: UILabel!
    
    
    
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
    
    override func viewDidAppear(animated: Bool) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Loading tip value
        let userTipPercentage = defaults.integerForKey("userTipPercentage")
        
        // Setting tipControl to whatever userTipPercentage (after loading tipValue)
        tipControl.selectedSegmentIndex = userTipPercentage
        
        // Loading # of people
        //let userNumberOfPeople = defaults.integerForKey("userNumberOfPeople")
        
        // Setting numberPeopleLabel to whatever value userNumberOfPeople has
        
    
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
        
        // Updating tip distribution
        let numberPeople = Double(numberPeopleLabel.text!)
        let distTip = total/numberPeople!
        tipPerPersonLabel.text = formatter.stringFromNumber(distTip)! + " each"
        
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
    
    @IBAction func onTapMinus(sender: AnyObject) {
        var numberPeople = Int(numberPeopleLabel.text!)
        if numberPeople > 1 {
            // Decrement # of people (--)
            numberPeople = numberPeople! - 1
            numberPeopleLabel.text = "\(numberPeople!)"
            
            // Currency formatting after inputting a value
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            
            // Get total, calculate & print amount/person
            let total = NSString(string: String(totalLabel.text!.characters.dropFirst())).doubleValue
            let distTip = total/Double(numberPeople!)
            tipPerPersonLabel.text = formatter.stringFromNumber(distTip)! + " each"
        }
    }
    
    @IBAction func onTapPlus(sender: AnyObject) {
        var numberPeople = Int(numberPeopleLabel.text!)
        numberPeople = numberPeople! + 1
        numberPeopleLabel.text = "\(numberPeople!)"
        
        // Currency formatting after inputting a value
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        // Get total, calculate & print amount/person
        let total = NSString(string: String(totalLabel.text!.characters.dropFirst())).doubleValue
        let distTip = total/Double(numberPeople!)
        tipPerPersonLabel.text = formatter.stringFromNumber(distTip)! + " each"
    }
    
}

