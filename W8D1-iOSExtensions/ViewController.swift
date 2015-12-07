//
//  ViewController.swift
//  W8D1-iOSExtensions
//
//  Created by Daniel Mathews on 2015-12-06.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var onOffLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        didBecomeActive()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func didBecomeActive() {
        if let defaults = NSUserDefaults(suiteName: "group.ToyBoxMedia.iOS8Extensions"){
            
            onOffLabel.text = defaults.boolForKey("isSwitchOn") ? "ON" : "OFF"
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

