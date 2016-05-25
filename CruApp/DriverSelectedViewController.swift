//
//  DriverSelectedViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 2/18/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class DriverSelectedViewController: UIViewController {

    @IBOutlet weak var driverContactInfoLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverNumber: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    
    var driver : Driver!

    var eventNames = [String]()
    var eventIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBClient.getData("events", dict: setEvents)
    }

    // Obtain event information from the database to an Object
    func setEvents(events: NSArray) {
        for event in events {
            let name = event["name"] as! String
            let id = event["_id"] as! String
            self.eventNames.append(name)
            self.eventIds.append(id)
        }
        
        for index in 0...(eventIds.count - 1) {
            if(eventIds[index] == driver.eventId) {
                eventName.text = eventNames[index]
                break
            }
        }
        
        driverName.text = "Driver's Name: " + driver.name
        driverNumber.text = "Driver's Phone Number: " + driver.phoneNumber
        successLabel.font = UIFont.boldSystemFontOfSize(24)
        successLabel.font = successLabel.font.fontWithSize(20)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(driver.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        departureTime.text = "Departure Time: " + dateFormatter.stringFromDate(date!)
    }
    
    @IBAction func submitPressed(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)

    }

}
