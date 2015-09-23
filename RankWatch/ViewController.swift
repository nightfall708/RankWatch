//
//  ViewController.swift
//  WatchMyRank
//
//  Created by Tal Shrestha on 22/09/15.
//  Copyright © 2015 Life on Air inc. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var save: UIButton!
    
    var savedAppName = NSUserDefaults.standardUserDefaults().stringForKey("appname")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("- iPhone app idle")
        save.enabled = false
        textField.addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)
        self.savedAppName = NSUserDefaults.standardUserDefaults().stringForKey("appname")
        textField.text = self.savedAppName
    }
    
    @IBAction func save(sender: AnyObject) {
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            if session.paired {
                //                if session.watchAppInstalled {
                //                    if session.watchDirectoryURL != nil {
                self.savedAppName = textField.text
                try! session.updateApplicationContext(["appname":textField.text!.lowercaseString])
                //                        session.transferCurrentComplicationUserInfo(["appname":textField.text!.lowercaseString])
                NSUserDefaults.standardUserDefaults().setObject(self.savedAppName, forKey: "appname")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.save.enabled = false
            } else {
                // show warning
            }
        }
    }
    
    func textChanged(textField: UITextField) {
        if textField.text?.lowercaseString != self.savedAppName?.lowercaseString {
            self.save.enabled = true
        } else {
            self.save.enabled = false
        }
    }
}

