//
//  AttractionDetailTableViewController.swift
//  WDW Explorer
//
//  Created by Matt on 10/15/15.
//  Copyright © 2015 Matt Sherman. All rights reserved.
//

import UIKit

class AttractionDetailTableViewController: UITableViewController {
    @IBOutlet var openedOnLabel: UILabel!
    @IBOutlet var notToBeMissedCell: UITableViewCell!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var extraMagicHoursMorningCell: UITableViewCell!
    @IBOutlet var extraMagicHoursEveningCell: UITableViewCell!
    
    var attraction: AttractionModel?
    
    let dateFormatter = NSDateFormatter()
    let numberFormatter = NSNumberFormatter()
    let dateComponentsFormatter = NSDateComponentsFormatter()
    
    let parkNames = [
        "magic-kingdom": "Magic Kingdom",
        "epcot": "Epcot",
        "hollywood-studios": "Hollywood Studios",
        "animal-kingdom": "Animal Kingdom"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .LongStyle
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: how to show loading message/indicator
        
        DataManager.loadAttraction(attraction!.permalink, park: attraction!.park, completion: { (attraction, error) -> Void in
            self.attraction = attraction!
            self.refreshTable()
        } )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            if let attraction = self.attraction {
                self.title = attraction.name
                self.navigationItem.prompt = self.parkNames[attraction.park]
                
                if let openedOn = attraction.openedOn {
                    self.openedOnLabel.text = self.dateFormatter.stringFromDate(openedOn)
                    self.openedOnLabel.hidden = false
                }
                
                if let notToBeMissed = attraction.notToBeMissed {
                    if notToBeMissed {
                        self.notToBeMissedCell.accessoryType = .Checkmark
                    }
                }
                
                if let duration = attraction.duration {
                    self.durationLabel.text = self.dateComponentsFormatter.stringFromTimeInterval(duration)
                    self.durationLabel.hidden = false
                }

                
                if let openExtraMagicHoursMorning = attraction.openExtraMagicHoursMorning {
                    if openExtraMagicHoursMorning {
                        self.extraMagicHoursMorningCell.accessoryType = .Checkmark
                    }
                }
                
                if let openExtraMagicHoursEvening = attraction.openExtraMagicHoursEvening {
                    if openExtraMagicHoursEvening {
                        self.extraMagicHoursEveningCell.accessoryType = .Checkmark
                    }
                }
            }
            
            return
        })
    }

}
