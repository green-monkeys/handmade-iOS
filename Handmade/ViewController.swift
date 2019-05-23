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
    var debug = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amazonLoginButton.sizeToFit()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func amazonLogin(_ sender: Any) {
        
        let request = AMZNAuthorizeRequest()
        var verified = false || self.debug
        request.scopes = [AMZNProfileScope.profile()]
        AMZNAuthorizationManager().authorize(request, withHandler: { (authres: AMZNAuthorizeResult?, canceled : Bool, error : Error?) -> () in
            print("attempting to log in")
            if(authres != nil) {
                print("logged in with amazon!!")
                print(authres!.user!.email)
                verified = true
            }
            else {
                print("did not authenticate with amazon!")
            }
            DispatchQueue.main.async {
                if(verified){
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.cga =
                        delegate.parseCgaFromJSON(data:
                        """
{"data" : {
    "email":"test@email.com",
    "id":2,
    "imageUrl":"https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-9/43437519_2116499585051348_1892370819774939136_n.jpg?_nc_cat=104&_nc_ht=scontent-sjc3-1.xx&oh=ed00fc5b5e92ac19027ce76c1623b242&oe=5D744F95",
    "first_name":"Patrick",
    "last_name": "Beninga",
    "payouts":[]
                        
}}
""".data(using: .utf8)!)
                    self.navigationController?.setViewControllers(
                        [self.storyboard!.instantiateViewController(withIdentifier: "ArtisanListViewController")],
                        animated: true)
                }
            }
            } as! AMZNAuthorizationRequestHandler)
        print("theoretically we do verification")
        
    }
    @IBAction func artisanLogin(_ sender: Any) {
        self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "loginVC"), animated: true)
    }
    
}

