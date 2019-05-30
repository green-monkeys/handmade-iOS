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
    @IBOutlet weak var lwaIndicator: UIActivityIndicatorView!
    @IBOutlet var amazonLoginButton: UIButton!
    @IBOutlet var createUserButton: UIButton!
    var debug = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amazonLoginButton.sizeToFit()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lwaIndicator.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }

    fileprivate func continueToArtisanListVC(_ verified: Bool, _ email: String?) {
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
            self.lwaIndicator.stopAnimating()
            self.lwaIndicator.isHidden = true
            
        }
    }
    
    @IBAction func amazonLogin(_ sender: Any) {
        self.lwaIndicator.isHidden = false
        self.lwaIndicator.startAnimating()
        let request = AMZNAuthorizeRequest()
        var email: String?
        var verified = false
        request.scopes = [AMZNProfileScope.profile()]
        AMZNAuthorizationManager().authorize(request, withHandler: { (authres: AMZNAuthorizeResult?, canceled : Bool, error : Error?) -> () in
            print("attempting to log in")
            if(authres != nil) {
                print("logged in with amazon!!")
                print(authres!.user!.email)
                email = authres!.user!.email
                verified = true
                self.continueToArtisanListVC(true, email)
            }
            else {
                print("did not authenticate with amazon!")
            }
        })
        
    }
    @IBAction func artisanLogin(_ sender: Any) {
        self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "loginVC"), animated: true)
    }
    
}

