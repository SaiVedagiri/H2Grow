//
//  ACViewController.swift
//  iOS Swift App
//
//  Created by Arya Tschand on 9/14/19.
//  Copyright © 2019 PEC. All rights reserved.
//

import UIKit

class ACViewController: UIViewController {

    var string123: String = ""
    
    @IBOutlet weak var AcScore: UILabel!
    @IBOutlet weak var mL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mL.isHidden = true
        printMessagesForUser(parameters: "water") {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
                    self.AcScore.text = self.string123
                    self.mL.isHidden = false
                }
            } else {
                print(error)
            }
        }
        DispatchQueue.main.async { // Correct
        }
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

}
