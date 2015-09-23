//
//  InterfaceController.swift
//  RankWatch WatchKit Extension
//
//  Created by Tal Shrestha on 23/09/15.
//  Copyright © 2015 Tal Shrestha. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var appNameLabel: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "contextArrived", object: nil)
    }
    
    func reloadData() {
        if NSUserDefaults.standardUserDefaults().stringForKey("appname") != nil {            appNameLabel.setText(NSUserDefaults.standardUserDefaults().stringForKey("appname"))
            appNameLabel.setTextColor(UIColor.greenColor())
        } else {
            appNameLabel.setText("Set from iPhone App")
            appNameLabel.setTextColor(UIColor.redColor())
        }
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
