//
//  MakeArtisanViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/16/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

class NewArtisanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var CGAEmail: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var password: UITextField!
    var presentingVC:ArtisanListViewController!
    var selectedImage:UIImage?
    @IBOutlet var isSmartSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.addImageButton.setImage(ArtisanListViewController.resizeImage(image: UIImage(named: "fake_artisan_image")!, targetSize: CGSize(width:80,height:80)), for: .normal)
        self.addImageButton.imageView!.layer.cornerRadius = 40
        self.addImageButton.imageView!.layer.masksToBounds = true
        self.firstName.becomeFirstResponder()
        self.phoneNumber.delegate = self
        self.lastName.delegate = self
        self.firstName.delegate = self
        
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
        if(self.password.text! != self.confirmPassword.text!){
            msg += "Please enter the same password\n"
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
        let urlString = "http://capstone406.herokuapp.com/cga?email="+self.CGAEmail.text!
        let url = URL(string: urlString)!
        print(url)
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) -> Void in
            if(error != nil){
                print(error)
                let alert = UIAlertController(title: "Alert", message: "Error connecting to server", preferredStyle: .alert)
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
            DispatchQueue.main.sync {
                guard let data = data else {return}
                guard let cga  = (UIApplication.shared.delegate as! AppDelegate).parseCgaFromJSON(data: data) else {
                    let alert = UIAlertController(title: "Alert", message: "No CGA with that email", preferredStyle: .alert)
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
                let params = [
                    "username" : self.username.text!,
                    "cgaId" : cga.id,
                    "firstName" : self.firstName.text!,
                    "lastName" : self.lastName.text!,
                    "password" : self.password.text!,
                    "phoneNumber" : self.phoneNumber.text!,
                    "isSmart" : String(self.isSmartSwitch.isOn)
                ]
                self.postNewArtisan(params: params)
                self.navigationController?.popViewController(animated: true)

            }
        }
        task.resume()
    }
    func postNewArtisan(params : [String : String]){
        let urlString = "http://capstone406.herokuapp.com/artisan"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = createBody(parameters: params,
                                      boundary: boundary,
                                      image: self.selectedImage,
                                      mimeType: "image/jpg",
                                      filename: self.username.text! + ".jpg")
        print(url)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) -> Void in
            if(error != nil){
                print("OOGA BOOGA WE GOT AN ERROR")
                print(error)
                return
            }
            DispatchQueue.main.sync {
                guard let data = data else {return}
                do{
                    print("HEEEREEEEE")
                    print(String(data: data, encoding: .utf8)!)
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: [])
                    guard let dataJson = jsonResponse as? [String: [String:Any]] else {return}
                    guard let x = dataJson["data"] else {return}
                    guard let firstName = x["first_name"] as? String else {return}
                    guard let lastName = x["last_name"] as? String else {return}
                    guard let username = x["username"] as? String else {return}
                    guard let imageURL = x["image"] as? String else {return}
                    let id = x["id"] as? Int
                    let phone  = x["phone"] as? Int ?? nil
                    var IdString = ""
                    if(id != nil){
                        IdString = String(id!)
                    }
                    var phoneString = ""
                    if(phone != nil){
                        phoneString = String(phone!)
                    }
                    let isSmart = x["is_smart"] as? Bool ?? false
                    (UIApplication.shared.delegate as! AppDelegate).artisan = Artisan(name: firstName + " " + lastName, username: username, phone: phoneString, isSmart: isSmart, localImage:self.selectedImage ?? UIImage(named: "fake_artisan_image")!, id:IdString)
                }catch let parsingError{
                    print("here")
                    print("Error", parsingError)
                    print("here")
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        task.resume()
        
    }
    func createBody(parameters: [String: String],
                    boundary: String,
                    image: UIImage?,
                    mimeType: String,
                    filename: String) -> Data {
        
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        if(image != nil){
            let data  =  image!.jpegData(compressionQuality: 0.7)!
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
        }
        body.appendString("--".appending(boundary.appending("--")))
        print(String(data: body as! Data, encoding: .utf8))
        return body as Data
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
