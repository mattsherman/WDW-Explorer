//
//  AttractionDetailTableViewController.swift
//  WDW Explorer
//
//  Created by Matt on 10/15/15.
//  Copyright © 2015 Matt Sherman. All rights reserved.
//

import UIKit

class AttractionDetailTableViewController: UITableViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var parkLabel: UILabel!
    @IBOutlet var openedOnLabel: UILabel!
    @IBOutlet var notToBeMissedLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var extraMagicHoursMorning: UILabel!
    @IBOutlet var extraMagicHoursEvening: UILabel!
    
    var attraction: AttractionModel?
    
    let dateFormatter = NSDateFormatter()
    let numberFormatter = NSNumberFormatter()
    let dateComponentsFormatter = NSDateComponentsFormatter()
    
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
                
                self.nameLabel.text = attraction.name
                self.parkLabel.text = attraction.park
                self.openedOnLabel.text = self.dateFormatter.stringFromDate(attraction.openedOn!)
                self.notToBeMissedLabel.text = attraction.notToBeMissed?.description
                self.durationLabel.text = self.dateComponentsFormatter.stringFromTimeInterval(attraction.duration!)
                self.extraMagicHoursMorning.text = attraction.openExtraMagicHoursMorning?.description
                self.extraMagicHoursEvening.text = attraction.openExtraMagicHoursEvening?.description
            }
            
            return
        })
    }

}
