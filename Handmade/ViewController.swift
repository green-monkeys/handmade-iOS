//
//  ViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/4/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var amazonLoginButton: UIButton!
    @IBOutlet var createUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amazonLoginButton.sizeToFit()
        self.navigationController?.navigationBar.isHidden = true

    }

    @IBAction func amazonLogin(_ sender: Any) {
        DispatchQueue.global().async {
            print("theoretically we do verification")
            let verified = true
            DispatchQueue.main.async {
                if(verified){
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.parseCgaFromJSON(data:
                        """
{
    "email":"test@email.com",
    "id":1,
    "imageUrl":"https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-9/43437519_2116499585051348_1892370819774939136_n.jpg?_nc_cat=104&_nc_ht=scontent-sjc3-1.xx&oh=ed00fc5b5e92ac19027ce76c1623b242&oe=5D744F95",
    "firstName":"Patrick",
    "lastName": "Beninga",
    "payouts":[]
                        
}
""".data(using: .utf8)!)
                    self.navigationController?.setViewControllers(
                        [self.storyboard!.instantiateViewController(withIdentifier: "ArtisanListViewController")],
                        animated: true)
                }
            }
        }
    }
    @IBAction func artisanLogin(_ sender: Any) {
        self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "loginVC"), animated: true)
    }
    
}

