//
//  LoginViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/16/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    var delegate:AppDelegate!
    var overlay = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        self.delegate = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.navigationBar.isHidden = false
        overlay.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        overlay.frame = self.view.frame
        self.view.addSubview(overlay)
        var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = overlay.center
        overlay.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.overlay.isHidden = true
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        self.overlay.isHidden = false
        let urlString = "http://capstone406.herokuapp.com/artisan/login?username=\(username.text!)&password=\(password.text!)"
        print(urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        print(url)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) -> Void in
            if(error != nil){
                print("OOGA BOOGA WE GOT AN ERROR")
                print(error)
                return
            }
            DispatchQueue.main.async {
                guard let data = data else {
                    let alert = UIAlertController(title: "Alert", message: "Invalid Artisan login", preferredStyle: .alert)
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
                    self.overlay.isHidden = true
                    return
                }
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: [])
                    guard let dataJson = jsonResponse as? [String: [String:Any]] else {
                        let alert = UIAlertController(title: "Alert", message: "Invalid Artisan login", preferredStyle: .alert)
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
                        self.overlay.isHidden = true
                        return
                        
                    }
                    guard let x = dataJson["data"] else {return}
                    print("HEREEEE \(x)")
                    guard let firstName = x["first_name"] as? String else {return}
                    guard let lastName = x["last_name"] as? String else {return}
                    guard let username = x["username"] as? String else {return}
                    let imageURL = x["image"] as? String ?? nil
                    let phone  = x["phone"] as? Int ?? nil
                    let id = x["id"] as? Int
                    var phoneString = ""
                    var IdString = ""
                    if(phone != nil){
                        phoneString = String(phone!)
                    }
                    if(id != nil){
                        IdString = String(id!)
                    }
                    let isSmart = x["is_smart"] as? Bool ?? false
                    self.delegate.artisan = Artisan(name: firstName + " " + lastName, username: username, phone:phoneString , isSmart: isSmart, Id:IdString)
                    if(imageURL != nil){
                        ArtisanListViewController.fetchImage(imageURL!, self.delegate.artisan!, cb:{return})
                    }
                    self.overlay.isHidden = true
                    let artView = self.storyboard?.instantiateViewController(withIdentifier: "ArtisanViewController") as! ArtisanViewController
                    artView.artisan = self.delegate.artisan
                    self.navigationController?.pushViewController(artView, animated: true)
                }catch let parsingError{
                    print("here")
                    print("Error", parsingError)
                    print("here")
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
