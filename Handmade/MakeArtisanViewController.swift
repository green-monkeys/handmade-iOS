//
//  MakeArtisanViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/16/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

class MakeArtisanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var username: UITextField!
    var presentingVC:ArtisanListViewController!
    var selectedImage:UIImage?
    @IBOutlet var isSmartSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageButton.setImage(ArtisanListViewController.resizeImage(image: UIImage(named: "fake_artisan_image")!, targetSize: CGSize(width:80,height:80)), for: .normal)
        self.addImageButton.imageView!.layer.cornerRadius = 40
        self.addImageButton.imageView!.layer.masksToBounds = true
        self.firstName.becomeFirstResponder()
        self.phoneNumber.delegate = self
        self.lastName.delegate = self
        self.firstName.delegate = self
        if let navController = self.navigationController, navController.viewControllers.count >= 2 {
            presentingVC = navController.viewControllers[navController.viewControllers.count - 2] as! ArtisanListViewController
        }

        // Do any additional setup after loading the view.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    @IBAction func addNewImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        DispatchQueue.main.async {
            self.addImageButton.setImage(ArtisanListViewController.resizeImage(image: image, targetSize: CGSize(width:80,height:80)), for: .normal)
            self.addImageButton.imageView!.layer.cornerRadius = 40
            self.addImageButton.imageView!.layer.masksToBounds = true
            self.selectedImage = image
        }

    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        var msg = ""
        if(self.firstName.text?.count == 0){
            msg +=  "Please enter your first name\n"
        }
        if(self.lastName.text?.count == 0){
            msg += "Please enter your last name\n"
        }
        if(self.username.text?.count  == 0){
            msg += "Please enter a valid username\n"
        }
        if(msg != ""){
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
            return
        }
        presentingVC.artisans.append(Artisan(name: firstName.text! + " " + lastName.text!, imageUrl: "", username: username.text!, phone: phoneNumber.text!, isSmart: self.isSmartSwitch.isOn, localImage:self.selectedImage ?? UIImage(named: "fake_artisan_image")!))
        self.navigationController?.popViewController(animated: true)
        
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
