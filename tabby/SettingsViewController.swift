//
//  SettingsViewController.swift
//  tabby
//
//  Created by Gale on 1/24/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var userTip: UISegmentedControl!
    @IBOutlet weak var userNumberPeople: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNumberPeople.text = "1"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipPercentage = defaults.integerForKey("userTipPercentage")
        userTip.selectedSegmentIndex = tipPercentage
        
        let numberPeople = defaults.integerForKey("userNumberPeople")
        if numberPeople != 0 {
            userNumberPeople.text = String(numberPeople)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func userTipDefaultSetter(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(userTip.selectedSegmentIndex, forKey: "userTipPercentage")
        defaults.synchronize()
    }
    
    @IBAction func userMinusPeopleSetter(sender: AnyObject) {
        var numberPeople = Int(userNumberPeople.text!)
        if numberPeople > 1 {
            // Decrement # of people (--)
            numberPeople = numberPeople! - 1
            userNumberPeople.text = "\(numberPeople!)"
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(userNumberPeople.text, forKey: "userNumberPeople")
        
    }
    
    @IBAction func userPlusPeopleSetter(sender: AnyObject) {
        var numberPeople = Int(userNumberPeople.text!)
        // Increase # of people (++)
        numberPeople = numberPeople! + 1
        userNumberPeople.text = "\(numberPeople!)"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(userNumberPeople.text, forKey: "userNumberPeople")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
