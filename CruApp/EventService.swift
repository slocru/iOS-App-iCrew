//
//  EventService.swift
//  CruApp
//
//  Created by Tammy Kong on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import Foundation

class EventService {
    
    func loadEvents(events: (NSDictionary) -> ()) {
        displayEvents(getEventData(events))
    }
    
    func displayEvents(completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) {
        request("http://localhost:3000/api/event/list", method: "GET", completionHandler: completionHandler)
        
    }
   
    func postEvent(eventName : String) -> () {
        let postURL: String = "http://localhost:3000/api/event/create"
        //let postURL: String = "http://localhost:3000/api/event/create?Content-Type=application/json"
        let reqURL = NSURL(string: postURL)
        let request = NSMutableURLRequest(URL: reqURL!)
        request.HTTPMethod = "POST"
        
        //let params: NSDictionary = ["name": [eventName, "adfads", "Event", "adfasd"], "location": ["233 Patrica Dr", "34adfad", "location",]
    
        let params: [AnyObject] = [["name": eventName, "location": ["postcode": 93405,"state": "California", "suburb": "San Luis Obispo", "street1": "233 Patricia Dr", "country": "UnitedStates"]]]
        
        do {
            let jsonPost = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = jsonPost
            
    
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
    
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                guard error == nil else {
                    print("error calling GET on /event/create")
                    print(error)
                    return
                }
    
                // parse the result as JSON, since that's what the API provides
                let post: NSDictionary
                do {
                    post = try NSJSONSerialization.JSONObjectWithData(responseData,
                        options: []) as! NSDictionary
                } catch  {
                    print("error parsing response from POST on /event")
                    return
                }
                // now we have the post, let's just print it to prove we can access it
//                print("The event is: " + (post["name"] as? String))
    
                // the post object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                if let eventName = post["name"] as? String
                {
                    print("The Event Name is: \(eventName)")
                }
            })
            task.resume()
        } catch {
            print("Error: cannot create JSON from event")
        }
    }
    
    
    func request(url:String, method:String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        let reqURL = NSURL(string: url)
        let request = NSMutableURLRequest(URL: reqURL!)
        request.HTTPMethod = method
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler)
        
        task.resume()
        
        return task
    }
    
    //func postEventData(events: (NSDictionary) -> ()
    
    func getEventData(events: (NSDictionary) -> ()) -> (NSData?, NSURLResponse?, NSError?)-> () {
        return {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            
            do {
                if(data == nil) {
                    print("ERROR: Cannot obtain data")
                } else {
                    let jsonList = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    dispatch_async(dispatch_get_main_queue(), {
                        for element in jsonList {
                            if let dict = element as? [String: AnyObject] {
                                events(dict)
                            }
                        }
                    })
                }
            } catch {
                print("ERROR: HTTP request");
            }
            
        }
    }
}