//
//  AttractionModel.swift
//  WDW Explorer
//
//  Created by Matt on 10/15/15.
//  Copyright © 2015 Matt Sherman. All rights reserved.
//

import Foundation

struct AttractionModel {
    // core
    var name: String
    var shortName: String
    var permalink: String
    var park: String // TODO: make enum
    // details
    var openedOn: NSDate?
    var notToBeMissed: Bool?
    var duration: NSTimeInterval?
    var openExtraMagicHoursMorning: Bool?
    var openExtraMagicHoursEvening: Bool?
    
    // TODO: is there a way to avoid having to define init?
    init(name: String, shortName: String, permalink: String, park: String, openedOn: NSDate? = nil, notToBeMissed: Bool? = nil, duration: NSTimeInterval? = nil, openExtraMagicHoursMorning: Bool? = nil, openExtraMagicHoursEvening: Bool? = nil) {
        self.name = name
        self.shortName = shortName
        self.permalink = permalink
        self.park = park
        self.openedOn = openedOn
        self.notToBeMissed = notToBeMissed
        self.duration = duration
        self.openExtraMagicHoursMorning = openExtraMagicHoursMorning
        self.openExtraMagicHoursEvening = openExtraMagicHoursEvening
    }
}