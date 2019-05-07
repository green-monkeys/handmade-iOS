//
//  ViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/4/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit
import LoginWithAmazon

class ViewController: UIViewController {
    @IBOutlet var amazonLoginButton: UIButton!
    @IBOutlet var createUserButton: UIButton!
    
    fileprivate func testParseCgaFromJSON() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.parseCgaFromJSON(data: """
{
            "data": {
            "id": 418,
            "email": "casato@calpoly.edu",
            "first_name": "Clay",
            "last_name": "Asato",
            "image": "https://capstone406.s3.us-west-1.amazonaws.com/cga/sM2oHeUN8xek6XqsSwlMotLCcMzavjx6UiNDIkklDfteEHZeGAo1l47Fj80mEMBB.jpg"
        }
    }
""".data(using: .utf8)!)
        print(delegate.cga == nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amazonLoginButton.sizeToFit()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func amazonLogin(_ sender: Any) {
        let request = AMZNAuthorizeRequest()
        var email : String? = nil
        var verified = false
        request.scopes = [AMZNProfileScope.profile()]
        AMZNAuthorizationManager().authorize(request, withHandler: { (authres: AMZNAuthorizeResult?, canceled : Bool, error : Error?) -> () in
            print("attempting to log in")
            if(authres != nil) {
                print("logged in with amazon!!")
                print(authres!.user!.email)
                verified = true
                email = authres!.user!.email

            }
            else {
                self.presentAuthAlert()
            }
        } )
        
            if(verified){
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let urlString = "https://capstone406.herokuapp.com/cga?email=\(email!)"
                let session = URLSession(configuration: URLSessionConfiguration.default)
                let request = URLRequest(url: URL(string: urlString)!)
                let task: URLSessionDataTask = session.dataTask(with: request)
                { (receivedData, response, error) -> Void in
                    if let data = receivedData {
                            print(data)
                            delegate.parseCgaFromJSON(data: data)
                            print("parsing")
                        DispatchQueue.main.sync() {
                            self.navigationController?.setViewControllers(
                                [self.storyboard!.instantiateViewController(withIdentifier: "ArtisanListViewController")],
                                animated: true)
                        }

                    }
                }
                task.resume()
            }
    }
    @IBAction func artisanLogin(_ sender: Any) {
        self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "loginVC"), animated: true)
    }
    func presentAuthAlert() {
        let alert = UIAlertController(title: "Couldn't Log In", message: "We couldn't log you in with that email.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}



