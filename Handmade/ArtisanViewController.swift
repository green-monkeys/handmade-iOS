//
//  ArtisanViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/11/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

class ArtisanViewController: UIViewController {
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var name: UILabel!
    var artisan:Artisan!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = artisan.fullImage ?? UIImage(named: "fake_artisan_image")!
        self.profilePicture.image = ArtisanListViewController.resizeImage(image:image ,
                                                  targetSize: CGSize(width: 180, height: 180))
        self.profilePicture.contentMode = .scaleAspectFit
        self.profilePicture.layer.cornerRadius = 90
        self.profilePicture.layer.masksToBounds =  true
        self.email.text = self.artisan.username
        self.name.text = self.artisan.name
        self.phoneNumber.text = self.artisan.phone
        self.phoneNumber.text! += self.artisan.isSmart ? " (Smart)" : ""
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
