//
//  LineViewController.swift
//  iOS Swift App
//
//  Created by Arya Tschand on 9/14/19.
//  Copyright © 2019 PEC. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore

enum MessageOption: Int {
    case noLineEnding,
    newline,
    carriageReturn,
    carriageReturnAndNewline
}

/// The option to add a \n to the end of the received message (to make it more readable)
enum ReceivedMessageOption: Int {
    case none,
    newline
}


class LineViewController: UIViewController, BluetoothSerialDelegate {
    
    @IBOutlet weak var Segmented: UISegmentedControl!
    
    @IBOutlet weak var Severity: UILabel!
    
    @IBOutlet weak var ConnectBtn: UIBarButtonItem!
    
    var string123 : String = ""
    var counter = 0
    
    @IBAction func Connect(_ sender: Any) {
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "ShowScanner", sender: self)
        } else {
            serial.disconnect()
            reloadView()
        }
    }
    
    @IBAction func SeverityChanged(_ sender: Any) {
        if Segmented.selectedSegmentIndex == 0 {
            //printMessagesForUser(parameters: "Temperature")
            getImageDB(value2: "health")
        } else if Segmented.selectedSegmentIndex == 1 {
            //printMessagesForUser(parameters: "Humidity")
            getImageDB(value2: "humidity")
        } else if Segmented.selectedSegmentIndex == 2 {
            //printMessagesForUser(parameters: "Air")
            getImageDB(value2: "soil")
        } else if Segmented.selectedSegmentIndex == 3 {
            //printMessagesForUser(parameters: "Severity")
            getImageDB(value2: "light")
        } else if Segmented.selectedSegmentIndex == 4 {
            //printMessagesForUser(parameters: "Severity")
            getImageDB(value2: "temp")
        } else if Segmented.selectedSegmentIndex == 5 {
            //printMessagesForUser(parameters: "Severity")
            getImageDB(value2: "height")
        }
    }
    
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serial = BluetoothSerial(delegate: self)
        
        // UI
        //mainTextView.text = ""
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LineViewController.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
    }
    
    func getImageDB(value2: String) {
        printMessagesForUser(parameters: value2) {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
                    let strBase64 = self.string123
                    if (self.string123.count > 0 && self.string123.count > 100) {
                        let dataDecoded:NSData = NSData(base64Encoded: strBase64, options: NSData.Base64DecodingOptions(rawValue: 0))!
                        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                        self.imageview.image = decodedimage
                    }
                }
            } else {
                print(error)
            }
        }
        DispatchQueue.main.async { // Correct
        }
    }
    
    func updateTitle() {
        printMessagesForUser(parameters: "healthVal") {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
                    if self.string123.count < 100 {
                        self.Severity.text = "Health Score: \(self.string123)"
                    }
                }
            } else {
                print(error)
            }
        }
        DispatchQueue.main.async { // Correct
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // bring the text field back down..
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
        }, completion: nil)
        
    }
    
    func textViewScrollToBottom() {
        //let range = NSMakeRange(NSString(string: mainTextView.text).length - 1, 1)
        //mainTextView.scrollRangeToVisible(range)
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        reloadView()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = "Disconnected"
        hud?.hide(true, afterDelay: 1.0)
    }
    
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.mode = MBProgressHUDMode.text
            hud?.labelText = "Bluetooth turned off"
            hud?.hide(true, afterDelay: 1.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
        updateTitle()
        getImageDB(value2: "health")
        
    }

    func printMessagesForUser(parameters: String, CompletionHandler: @escaping (Bool?, Error?) -> Void){
        let json = [parameters]
        print(json)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            
            let url = NSURL(string: "https://h2grow.herokuapp.com/api")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if let string = String(data: data!, encoding: .utf8) {
                    self.string123 = string
                    CompletionHandler(true,nil)
                    
                    //self.Severity.text = "hello"
                } else {
                }
                
                //self.Severity.text = "test"
                
            }
            task.resume()
        } catch {
            
            print(error)
        }
    }
    
    func serialDidReceiveString(_ message: String) {
        print(message)
        let messagearray = message.components(separatedBy: ",")
        printMessagesForUser(parameters: message) {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
                    let array = self.string123.components(separatedBy: ",")
                        if self.Segmented.selectedSegmentIndex == 0 {
                            //printMessagesForUser(parameters: "Temperature")
                            self.getImageDB(value2: "health")
                            if array[0].count < 100 {
                                self.Severity.text = "Health Score: \(array[0])"
                                serial.sendMessageToDevice(array[0])
                            }
                        } else if self.Segmented.selectedSegmentIndex == 1 {
                            //printMessagesForUser(parameters: "Humidity")
                            self.getImageDB(value2: "humidity")
                            if array[0].count < 100 {
                                self.Severity.text = "Humidity: \(messagearray[4])%"
                                serial.sendMessageToDevice(array[0])
                            }
                        } else if self.Segmented.selectedSegmentIndex == 2 {
                            //printMessagesForUser(parameters: "Air")
                            self.getImageDB(value2: "soil")
                            if array[0].count < 100 {
                                self.Severity.text = "Soil Moisture: \(messagearray[1])%"
                                serial.sendMessageToDevice(array[0])
                            }
                        } else if self.Segmented.selectedSegmentIndex == 3 {
                            //printMessagesForUser(parameters: "Severity")
                            self.getImageDB(value2: "light")
                            if array[0].count < 100 {
                                self.Severity.text = "Light: \(messagearray[2])%"
                                serial.sendMessageToDevice(array[0])
                            }
                        } else if self.Segmented.selectedSegmentIndex == 4 {
                            //printMessagesForUser(parameters: "Severity")
                            self.getImageDB(value2: "temp")
                            if array[0].count < 100 {
                                self.Severity.text = "Temperature: \(messagearray[3]) Celsius"
                                serial.sendMessageToDevice(array[0])
                            }
                        } else if self.Segmented.selectedSegmentIndex == 5 {
                            //printMessagesForUser(parameters: "Severity")
                            self.getImageDB(value2: "height")
                            if array[0].count < 100 {
                                self.Severity.text = "Height: \(messagearray[0]) cm"
                                serial.sendMessageToDevice(array[0])
                            }
                        }
                }
            } else {
                print(error)
            }
        }
        DispatchQueue.main.async { // Correct
        }
        
    }
    
    @objc func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        
        if serial.isReady {
            ConnectBtn.title = "Disconnect"
            ConnectBtn.tintColor = UIColor.red
            ConnectBtn.isEnabled = true
            serial.sendMessageToDevice("initialize")
        } else if serial.centralManager.state == .poweredOn {
            ConnectBtn.title = "Connect"
            ConnectBtn.tintColor = view.tintColor
            ConnectBtn.isEnabled = true
            serial.sendMessageToDevice("DISCONNECT")
        } else {
            ConnectBtn.title = "Connect"
            ConnectBtn.tintColor = view.tintColor
            ConnectBtn.isEnabled = false
            serial.sendMessageToDevice("DISCONNECT")
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // animate the text field to stay above the keyboard
        var info = (notification as NSNotification).userInfo!
        let value = info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        _ = value.cgRectValue
        
        //TODO: Not animating properly
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
        }, completion: { Bool -> Void in
            self.textViewScrollToBottom()
        })
    }

}
