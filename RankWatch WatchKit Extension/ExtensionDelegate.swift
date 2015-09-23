//
//  ExtensionDelegate.swift
//  WatchMyRank WatchKit Extension
//
//  Created by Tal Shrestha on 22/09/15.
//  Copyright © 2015 Life on Air inc. All rights reserved.
//

import WatchKit
import ClockKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    override init (){
        super.init()
        let session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
    }
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        for (key, value) in applicationContext {
            NSUserDefaults.standardUserDefaults().setObject(applicationContext[key], forKey: key)
            print("saved \(key) => \(value)")
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        CLKComplicationServer.sharedInstance().reloadTimelineForComplication(CLKComplicationServer.sharedInstance().activeComplications[0])
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "contextArrived", object: nil))
    }
}
