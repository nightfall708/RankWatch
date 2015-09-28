//
//  ComplicationController.swift
//  WatchMyRank WatchKit Extension
//
//  Created by Tal Shrestha on 22/09/15.
//  Copyright © 2015 Life on Air inc. All rights reserved.
//

import ClockKit
import WatchConnectivity

class ComplicationController: NSObject, CLKComplicationDataSource, WCSessionDelegate {
    
    // MARK: - Timeline Configuration
    var test: String?
    var responseData: NSData?
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.None])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        let date = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        print("test = \(self.test), date = \(date)")
        self.test = "hello"
        
        
        let url = NSURL(string:"https://itunes.apple.com/us/rss/toppaidapplications/limit=100/genre=6011/json")!
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url) { (data, _, error) -> Void in
            if data != nil && error == nil {
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.init(rawValue: 0))
                let rankObject = RankObject(json: json)
                let entry = self.timeLineEntryForComplicationWithRankObject(rankObject, family: complication.family)
                //                let entry = CLKComplicationTimelineEntry(rankObject: rankObject, family: complication.family)
                handler(entry)
            }
        }
        dataTask.resume()
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        let minutes: NSTimeInterval = 30
        let dateInOneHour = NSDate(timeInterval: 60*minutes, sinceDate: NSDate())
        handler(dateInOneHour) // in one hour
    }
    
    func requestedUpdateDidBegin() {
        CLKComplicationServer.sharedInstance().reloadTimelineForComplication(CLKComplicationServer.sharedInstance().activeComplications[0])
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let entry = self.timeLineEntryForComplicationWithRankObject(nil, family: complication.family)
        handler(entry?.complicationTemplate)
    }
    
    func timeLineEntryForComplicationWithRankObject(rankObject: RankObject?, family: CLKComplicationFamily) -> CLKComplicationTimelineEntry? {
        let stringNAString = "n/a"
        var template: CLKComplicationTemplate?
        if family == .CircularSmall {
            if rankObject != nil {
                let tempTemplate = CLKComplicationTemplateCircularSmallStackText()
                tempTemplate.line1TextProvider = CLKSimpleTextProvider(text: rankObject!.rank)
                tempTemplate.line2TextProvider = CLKSimpleTextProvider(text: rankObject!.change)
                template = tempTemplate
            } else {
                let tempTemplate = CLKComplicationTemplateCircularSmallSimpleText()
                tempTemplate.textProvider = CLKSimpleTextProvider(text: stringNAString)
                template = tempTemplate
            }
        } else if family == .ModularSmall {
            if rankObject != nil {
                let tempTemplate = CLKComplicationTemplateModularSmallStackText()
                tempTemplate.line1TextProvider = CLKSimpleTextProvider(text: rankObject!.rank)
                tempTemplate.line2TextProvider = CLKSimpleTextProvider(text: rankObject!.change)
                template = tempTemplate
            } else {
                let tempTemplate = CLKComplicationTemplateModularSmallSimpleText()
                tempTemplate.textProvider = CLKSimpleTextProvider(text: stringNAString)
                template = tempTemplate
            }
        } else if family == .UtilitarianSmall {
            let tempTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            if rankObject != nil {
                tempTemplate.textProvider = CLKSimpleTextProvider(text: "\(rankObject!.rank) \(rankObject!.change)")
            } else {
                tempTemplate.textProvider = CLKSimpleTextProvider(text: stringNAString)
            }
            
            template = tempTemplate
        }
        if template != nil {
            let timelineEntry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template!)
            return timelineEntry
        }
        return nil
    }
}

extension CLKComplicationTimelineEntry {
    
    convenience init?(rankObject: RankObject?, family: CLKComplicationFamily) {
        let stringNAString = ">100"
        var template: CLKComplicationTemplate?
        if family == .CircularSmall {
            if rankObject != nil {
                let tempTemplate = CLKComplicationTemplateCircularSmallStackText()
                tempTemplate.line1TextProvider = CLKSimpleTextProvider(text: rankObject!.rank)
                tempTemplate.line2TextProvider = CLKSimpleTextProvider(text: rankObject!.change)
                template = tempTemplate
            } else {
                let tempTemplate = CLKComplicationTemplateCircularSmallSimpleText()
                tempTemplate.textProvider = CLKSimpleTextProvider(text: stringNAString)
                template = tempTemplate
            }
        } else if family == .ModularSmall {
            if rankObject != nil {
                let tempTemplate = CLKComplicationTemplateModularSmallStackText()
                tempTemplate.line1TextProvider = CLKSimpleTextProvider(text: rankObject!.rank)
                tempTemplate.line2TextProvider = CLKSimpleTextProvider(text: rankObject!.change)
                template = tempTemplate
            } else {
                let tempTemplate = CLKComplicationTemplateModularSmallSimpleText()
                tempTemplate.textProvider = CLKSimpleTextProvider(text: stringNAString)
                template = tempTemplate
            }
        } else if family == .UtilitarianSmall {
            let tempTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            if rankObject != nil {
                tempTemplate.textProvider = CLKSimpleTextProvider(text: "\(rankObject!.rank) \(rankObject!.change)")
            } else {
                tempTemplate.textProvider = CLKSimpleTextProvider(text: stringNAString)
            }
            template = tempTemplate
        }
        self.init(date: NSDate(), complicationTemplate: template!)
    }
}

class RankObject : NSObject {
    var rank: String
    var change: String
    
    init?(json: AnyObject) {
        var rank = 0
        let feed = json["feed"]!
        let array = feed!["entry"]!
        let prevRankNumber: NSNumber? = NSUserDefaults.standardUserDefaults().objectForKey("prevRank") as! NSNumber!
        let appname = NSUserDefaults.standardUserDefaults().stringForKey("appname")
        var rankString: String?
        var changeString: String?
        if appname == nil {
            rankString = ""
            changeString = "n/a"
        } else {
            for (var i = 1; i <= 100; i++) {
                let name = array![i-1]["im:name"]!
                if (name!["label"]! as? String)?.lowercaseString == appname {
                    rank = i;
                    break
                }
            }
            if rank == 0 {
                // bellow 100
                rankString = ""
                changeString = ">100"
            }
            else if prevRankNumber != nil {
                // stay like before
                let prevRank = prevRankNumber!.integerValue
                if prevRank == rank {
                    rankString = NSUserDefaults.standardUserDefaults().stringForKey("rankString")!
                    changeString = NSUserDefaults.standardUserDefaults().stringForKey("changeString")!
                } else {
                    rankString = "\(rank)"
                    let diff = prevRank - rank
                    if diff > 0 {
                        changeString = "(+\(diff))"
                    } else if diff < 0 {
                        changeString = "(\(diff))"
                    }
                    NSUserDefaults.standardUserDefaults().setObject(NSNumber(integer: rank), forKey: "prevRank")
                }
            } else {
                rankString = "\(rank)"
                changeString = "(-)"
                NSUserDefaults.standardUserDefaults().setObject(NSNumber(integer: rank), forKey: "prevRank")
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(rankString, forKey: "rankString")
        NSUserDefaults.standardUserDefaults().setObject(changeString, forKey: "changeString")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.rank = rankString!
        self.change = changeString!
    }
}
