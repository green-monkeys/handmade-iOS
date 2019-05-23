//
//  ArtisanViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/11/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit
import MessageUI

class ArtisanViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet var phoneNumber: UIButton!
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
        self.phoneNumber.setTitle("\(self.artisan.phone ?? "None") \(self.artisan.isSmart ? " (Smart)" : "")", for: .normal)
    }
    
    @IBAction func goToText(_ sender: Any) {
        if(self.artisan.phone == nil){
            return
        }
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
            return
        }
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self


        // Configure the fields of the interface.
        composeVC.recipients = [self.artisan.phone ?? ""]
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @IBAction func toPayouts(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let payoutTVC = self.storyboard?.instantiateViewController(withIdentifier: "payoutVC") as! PayoutTableViewController
        payoutTVC.artisan = self.artisan
        self.navigationController?.pushViewController(payoutTVC, animated:  true)
        
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
