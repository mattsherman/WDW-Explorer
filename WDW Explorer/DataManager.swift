import Foundation

class DataManager {
    static let attractionsUrlTemplate = "http://touringplans.com/%@/attractions.json"
    static let attractionDetailUrlTemplate = "http://touringplans.com/%@/attractions/%@.json"
    
    static func loadAttractions(completion:(attractions: [AttractionModel]?, error: NSError?) -> Void) {
        var allAttractions = [AttractionModel]()
        
        // TODO: how to do this in a more elegant fashion
        
        loadAttractionsForPark("magic-kingdom", completion: { (attractions, error) -> Void in
            allAttractions.appendContentsOf(attractions!)
            
            loadAttractionsForPark("epcot", completion: { (attractions, error) -> Void in
                allAttractions.appendContentsOf(attractions!)
                
                loadAttractionsForPark("hollywood-studios", completion: { (attractions, error) -> Void in
                    allAttractions.appendContentsOf(attractions!)
                    
                    loadAttractionsForPark("animal-kingdom", completion: { (attractions, error) -> Void in
                        allAttractions.appendContentsOf(attractions!)
                        
                        allAttractions.sortInPlace({ (attraction1, attraction2) -> Bool in
                            return attraction1.name.caseInsensitiveCompare(attraction2.name) == .OrderedAscending                            
                        })
                        
                        completion(attractions: allAttractions, error: nil)
                    })
                })
            })
        })
    }
    
    static func loadAttractionsForPark(park: String, completion:(attractions: [AttractionModel]?, error: NSError?) -> Void) {
        // TODO: handle when NSURL returns nil
        let url = NSURL(string: String(format: attractionsUrlTemplate, park))
        
        DataManager.loadDataFromURL(url!, completion: { (data, error) -> Void in
            let attractions = parseAttractionsJSON(park, data: data!)
            completion(attractions: attractions, error: nil)
        })
    }
    
    static func parseAttractionsJSON(park: String, data: NSData) -> [AttractionModel] {
        var attractions = [AttractionModel]()
        let json = JSON(data: data);
        
        if let attractionsArray = json.array {
            for attractionDict in attractionsArray {
                let attraction = AttractionModel(
                    name: attractionDict["name"].string!,
                    shortName: attractionDict["short_name"].string!,
                    permalink: attractionDict["permalink"].string!,
                    park: park
                )
                
                attractions.append(attraction)
            }
        }
        
        return attractions
    }
    
    static func loadAttraction(permalink: String, park: String, completion:(attraction: AttractionModel?, error: NSError?) -> Void) {
        // TODO: handle when NSURL returns nil
        let url = NSURL(string: String(format: attractionDetailUrlTemplate, park, permalink))
        
        DataManager.loadDataFromURL(url!, completion: { (data, error) -> Void in
            let attraction = parseAttractionDetailJSON(permalink, park: park, data: data!)
            completion(attraction: attraction, error: nil)
        })

    }

    static func parseAttractionDetailJSON(permalink: String, park: String, data: NSData) -> AttractionModel {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let json = JSON(data: data)
        
        let attraction = AttractionModel(
            name: json["name"].string!,
            shortName: json["short_name"].string!,
            permalink: permalink,
            park: park,
            openedOn: dateFormatter.dateFromString(json["opened_on"].string!),
            notToBeMissed: json["not_to_be_missed"].bool!,
            duration: NSTimeInterval(json["duration"].number!.doubleValue * 60),
            openExtraMagicHoursMorning: json["open_emh_morning"].bool!,
            openExtraMagicHoursEvening: json["open_emh_evening"].bool!
        )
        
        return attraction
    }
    
    static func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            completion(data: data!, error: nil)
        }
    
        task.resume()
    }
}