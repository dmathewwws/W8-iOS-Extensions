//
//  TodayViewController.swift
//  PressMe
//
//  Created by Daniel Mathews on 2015-12-06.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var onOffLabel: UILabel!
    @IBOutlet weak var onOFFSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        if let defaults = NSUserDefaults(suiteName: "group.ToyBoxMedia.iOS8Extensions"){
            
            let isOn = defaults.boolForKey("isSwitchOn")
            onOFFSwitch.on = isOn
            onOffLabel.text = isOn ? "ON" : "OFF"
            
        }
        
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        
        onOffLabel.text = sender.on ? "ON" : "OFF"
        
        if let defaults = NSUserDefaults(suiteName: "group.ToyBoxMedia.iOS8Extensions"){
            
            defaults.setBool(sender.on, forKey: "isSwitchOn")
            
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        
        
        
        completionHandler(NCUpdateResult.NewData)
    }
    
}
