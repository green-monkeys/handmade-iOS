//
//  LoginViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/16/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let testEmail = "test_cga@email.com"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        let urlString = "https://capstone406.herokuapp.com/cga?email=" + testEmail
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: urlString)!)
        let task: URLSessionDataTask = session.dataTask(with: request)
        { (receivedData, response, error) -> Void in
            
            if let data = receivedData {
                do {
                    let decoder = JSONDecoder()
                    let rawDataString = String(data: data, encoding: String.Encoding.utf8)
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    let dict = jsonResponse!["data"] as? [String:AnyObject]
                    for (key,value) in dict! {
                        if value is [String:AnyObject] {
                            print("\(key) is a Dictionary")
                        }
                        else if value is [AnyObject] {
                            print("\(key) is an Array")
                        }
                        else {
                            print(type(of: value))
                        }
                    }
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.parseCgaFromJSON(data: data)
                    
                } catch {
                    print("Exception on Decode: \(error)")
                }
            }
        }
        task.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
