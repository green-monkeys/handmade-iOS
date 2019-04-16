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
            print("theoretcially we do verification")
            let verified = true
            DispatchQueue.main.async {
                if(verified){
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

