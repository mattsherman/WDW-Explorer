//
//  AttractionTableViewController.swift
//  WDW Explorer
//
//  Created by Matt on 10/15/15.
//  Copyright © 2015 Matt Sherman. All rights reserved.
//

import UIKit

class AttractionTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var searchController: UISearchController?
    
    // TODO: move to DataManager
    var attractions = [AttractionModel]()
    var filteredAttractions = [AttractionModel]()
    let parks = ["all", "magic-kingdom", "epcot", "hollywood-studios", "animal-kingdom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.delegate = self
            controller.searchBar.scopeButtonTitles = ["All", "MK", "Epcot", "DHS", "DAK"]
            // TODO: figure out how to get minimal style to work without
            // search field and scope buttons overlapping or scope buttons
            // being visible initially but not working
            //controller.searchBar.searchBarStyle = UISearchBarStyle.Minimal
            //controller.searchBar.showsScopeBar = true
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        // TODO: how to show loading message/indicator
        
        DataManager.loadAttractions({ (attractions, error) -> Void in
            self.attractions = attractions!
            self.refreshTable()
        } )
    }

    override func viewWillAppear(animated: Bool) {
        if let searchController = searchController {
            searchController.searchBar.hidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        if let searchController = searchController {
            searchController.searchBar.sizeToFit()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getAttractionCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let attraction = getAttractionForRowAtIndexPath(indexPath)
        
        cell.textLabel!.text = attraction.name
        cell.accessoryType = .DisclosureIndicator

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "attractionDetail" {
            let attractionDetailViewController = segue.destinationViewController as! AttractionDetailTableViewController
            
            let indexPath = tableView.indexPathForSelectedRow!
            
            attractionDetailViewController.attraction = getAttractionForRowAtIndexPath(indexPath)
            
            if let searchController = searchController {
                searchController.searchBar.hidden = true
            }
        }
    }
    
    func refreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    func filterAttractions() {
        filteredAttractions = attractions.filter({ (attraction: AttractionModel) -> Bool in
            if let searchController = searchController {
                var stringMatch = true
                
                if let searchText = searchController.searchBar.text {
                    if !searchText.isEmpty {
                        stringMatch = attraction.name.rangeOfString(searchText) != nil
                    }
                }
                
                var parkMatch = true
                let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
                
                if scopeIndex > 0 {
                    parkMatch = attraction.park == parks[scopeIndex]
                }
                
                return parkMatch && stringMatch
            }
            
            return false
        })
    }
    
    func getAttractionCount() -> Int {
        if let searchController = searchController {
            if searchController.active {
                return filteredAttractions.count
            }
        }
        
        return attractions.count
    }
    
    func getAttractionForRowAtIndexPath(indexPath: NSIndexPath) -> AttractionModel {
        if let searchController = searchController {
            if searchController.active {
                return filteredAttractions[indexPath.row]
            }
        }
        
        return attractions[indexPath.row]
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterAttractions()
        refreshTable()
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterAttractions()
        refreshTable()
    }
}
