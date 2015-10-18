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
    let name: String
    let shortName: String
    let permalink: String
    let park: String // TODO: make enum
    // details
    let openedOn: NSDate?
    let notToBeMissed: Bool?
    let duration: NSTimeInterval?
    let openExtraMagicHoursMorning: Bool?
    let openExtraMagicHoursEvening: Bool?
    
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