//
//  HelpTableViewController.swift
//  
//
//  Created by Arya Tschand on 9/14/19.
//

import UIKit
import Foundation
import MessageUI
import MapKit
import CoreLocation
import FirebaseDatabase

class HelpTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    var names: [String] = ["AboutGrownNYC", "Green New Yorkers", "NYC Grassroots Alliance"]
    var numbers: [String] = ["(718)-637-9134", "(917)-348-1349", "(718)-193-5839"]
    var emails: [String] = ["grownyc@gmail.com", "greenny@gmail.com", "grassrootsnyc@outlook.com"]
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //printMessagesForUser(parameters: "hello")
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            //print(currentLocation.coordinate.latitude)
            //print(currentLocation.coordinate.longitude)
            
        }
        
        //let location = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        //var geocoder = CLGeocoder()
        // Geocode Location
        //geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            //self.processResponse(withPlacemarks: placemarks, error: error)
        //}
    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0
    var addressString : String = ""
    
    func getDB(value: String) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            var temp: String = value?["value"] as! String
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
    }
    
    func printMessagesForUser(parameters: String) -> Void {
            let json = [parameters]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
                let url = NSURL(string: "https://h2hacks1.herokuapp.com/api")!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                    if let string = String(data: data!, encoding: .utf8) {
                        print(string)
                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                }
                
                task.resume()
            } catch {
                print(error)
            }
        }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Set up emailing feature
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath)
        cell.textLabel?.text = names[indexPath.row] + " - " + numbers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([emails[indexPath.row]])
        composeVC.setSubject("Environmental Volunteer")
        self.present(composeVC, animated: true, completion: nil)
    }

}
