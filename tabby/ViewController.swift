//
//  ViewController.swift
//  tabby
//
//  Created by Gale on 12/28/15.
//  Copyright © 2015 Gale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var numberPeopleLabel: UILabel!
    @IBOutlet weak var tipPerPersonLabel: UILabel!
    
    let tipPercentages = [0.18, 0.2, 0.22]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial currency formatting when app starts
        let currencySymbol = NSLocale.currentLocale().objectForKey(NSLocaleCurrencySymbol) as! String
        
        // Initializing values
        billField.placeholder = (currencySymbol as String) + "0.00"
        tipLabel.text = (currencySymbol as String) + "0.00"
        totalLabel.text =  (currencySymbol as String) + "0.00"
        tipPerPersonLabel.text = (currencySymbol as String) + "0.00"
        numberPeopleLabel.text = "1"
        
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
        let values = calculateTipTotal()
        tipLabel.text = currencyFormatter(values.tip)
        totalLabel.text = currencyFormatter(values.total)
        updateAmountEach(values.total)
        
        // Loading # of people
        let userNumberOfPeople = defaults.integerForKey("userNumberPeople")
        
        // Setting numberPeopleLabel to whatever value userNumberOfPeople has as long as userNumberOfPeople isn't = to 0
        if userNumberOfPeople != 0 {
            numberPeopleLabel.text = String(userNumberOfPeople)
            let total = NSString(string: String(totalLabel.text!.characters.dropFirst())).doubleValue
            updateAmountEach(total)
        }
    }
    
    // MARK: - Calculating Tip 
    
    func calculateTipTotal () -> (tip: Double, total: Double) {
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPercentage
        let total = tip + billAmount
        
        return (tip, total)
    }
    
    // MARK: - Currency Formatter
    
    /********************************************************************
     * Parameter: Double that represents monetary value
     * Return: String that is formatted to show correct currency display
     ********************************************************************/
    
    func currencyFormatter (moneyValue: Double) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        return formatter.stringFromNumber(moneyValue)!
    }
    
    // MARK: - Amount Updater
    
    func updateAmountEach (total:Double) {
        let numberPeople = Double(numberPeopleLabel.text!)
        
        let distributedAmount = total/numberPeople!
        
        tipPerPersonLabel.text = currencyFormatter(distributedAmount) + " each"
        
    }
    
    // MARK: - TextField Functions

    @IBAction func onEditingChange(sender: AnyObject) {
        let values = calculateTipTotal()
        
        // Currency formatting after inputting a value
        
        tipLabel.text = currencyFormatter(values.tip)
        totalLabel.text = currencyFormatter(values.total)
        
        // Updating tip distribution
        updateAmountEach(values.total)
        
        //Storing bill amount
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(billField.text, forKey:"billAmount")
        defaults.setObject(NSDate.init(), forKey: "billDate")
        defaults.synchronize()
    }
    
    // MARK: - Button Functions

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
            
            // Get total, calculate & print amount/person
            let total = NSString(string: String(totalLabel.text!.characters.dropFirst())).doubleValue
            updateAmountEach(total)
        }
    }
    
    @IBAction func onTapPlus(sender: AnyObject) {
        var numberPeople = Int(numberPeopleLabel.text!)
        numberPeople = numberPeople! + 1
        numberPeopleLabel.text = "\(numberPeople!)"
        
        // Get total, calculate & print amount/person
        let total = NSString(string: String(totalLabel.text!.characters.dropFirst())).doubleValue
        updateAmountEach(total)
    }
    
}

