//
//  ArtisanListViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/16/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

class ArtisanCell: UITableViewCell{
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var ArtisanName: UILabel!
    
}
class Artisan{
    var image:UIImage?
    var fullImage:UIImage?
    var name:String
    var phone:String?
    var isSmart:Bool
    var username:String
    var localImage = false
    init(name:String, imageUrl:String, username:String, phone:String?, isSmart:Bool) {
        self.name = name
        self.phone = phone
        self.isSmart = isSmart
        self.username = username
    }
    init(name:String, imageUrl:String, username:String, phone:String?, isSmart:Bool, localImage:UIImage) {
        self.name = name
        self.phone = phone
        self.isSmart = isSmart
        self.username = username
        self.fullImage = localImage
        self.image = ArtisanListViewController.resizeImage(image: self.fullImage!, targetSize: CGSize(width:50,height:50))
    }
}
class ArtisanListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var artisanTableView: UITableView!
    @IBOutlet var profileImage: UIImageView!
    var artisans = [Artisan]()
    var delegate = UIApplication.shared.delegate as! AppDelegate
    let overlay = UIView()
    var fullName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        self.profileImage.image = ArtisanListViewController.resizeImage(image:UIImage(named: "profile.jpg")!, targetSize:CGSize(width:80, height:80))//This needs to be changed later
        overlay.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        overlay.frame =  self.artisanTableView.frame
        self.view.addSubview(overlay)
        var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = overlay.center
        overlay.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.profileImage.layer.cornerRadius = 40.0
        self.profileImage.layer.masksToBounds =  true
        self.artisanTableView.delegate =  self
        self.artisanTableView.dataSource =  self
        self.artisanTableView.backgroundColor = self.view.backgroundColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Artisans"
        self.getArtisans()
        self.artisanTableView.layer.borderWidth = 2
        self.artisanTableView.layer.borderColor = UIColor.white.cgColor
        self.fullName = "\(delegate.cga?.firstName) \(delegate.cga?.lastName)"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = self.artisanTableView.indexPathForSelectedRow {
            self.artisanTableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        self.artisanTableView.reloadData()
    }
    @objc func logOut (){
        DispatchQueue.global().async {
            AMZNAuthorizationManager().signOut({ (err: Error?) in
                if(err != nil) {
                    print(err!)
                }
                else {
                    print("signed out of Amazon")
                }
            })
            //amazon logout stuff
            DispatchQueue.main.async{
                self.navigationController?.setViewControllers(
                    [self.storyboard!.instantiateViewController(withIdentifier: "rootViewController")],
                    animated: true)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artisans.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArtisanViewController") as! ArtisanViewController
        vc.artisan = self.artisans[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        print("hi")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artisanCell") as! ArtisanCell
        cell.profileImage.image = self.artisans[indexPath.row].image ?? ArtisanListViewController.resizeImage(image: UIImage(named: "fake_artisan_image")!, targetSize: CGSize(width:50,height:50))
        cell.ArtisanName.text = self.artisans[indexPath.row].name
        cell.profileImage.layer.cornerRadius = 25.0
        cell.profileImage.layer.masksToBounds =  true
        let bgView = UIView()
        bgView.backgroundColor = self.view.backgroundColor
        cell.selectedBackgroundView = bgView
        print("did an image thing")
        return cell
    }
    func getArtisans(){
        if ((self.delegate.cga) != nil){
            let urlString = "http://capstone406.herokuapp.com/cga/artisans?email="+delegate.cga!.email
            let url = URL(string: urlString)!
            print(url)
            let task = URLSession.shared.dataTask(with: url){
                (data, response, error) -> Void in
                if(error != nil){
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    guard let data = data else {return}
                    self.parseArtisans(data: data)
                    print(self.artisans)
                    self.artisanTableView.reloadData()
                    self.overlay.removeFromSuperview()
                    self.overlay.subviews[0].removeFromSuperview()
                }
            }
            task.resume()
        }
        else {
            print("error authenticating")
        }

    }
    func parseArtisans(data:Data){
        do{
            let jsonResponse = try JSONSerialization.jsonObject(with:
            data, options: [])
            guard let dataJson = jsonResponse as? [String: [[String:Any]]] else {return}
            print(dataJson)
            guard let json = dataJson["data"] else {return}
            for x in json {
                guard let firstName = x["first_name"] as? String else {return}
                guard let lastName = x["last_name"] as? String else {return}
                guard let username = x["username"] as? String else {return}
                let imageURL = "http://capstone406.herokuapp.com/artisan/image?username=" + username
                let phone  = x["phone"] as? Int ?? nil
                var phoneString = ""
                if(phone != nil){
                    phoneString = String(phone!)
                }
                let isSmart = x["is_smart"] as? Bool ?? false
                let art = Artisan(name: firstName + " " + lastName , imageUrl: imageURL, username: username, phone:phoneString , isSmart: isSmart)
                artisans.append(art)
                self.fetchImage(imageURL, art)
            }
            
        }catch let parsingError{
            print("here")
            print("Error", parsingError)
            print("here")
        }
        
    }
    func fetchImage(_ urlString: String, _ a:Artisan){
        print("Download Started")
        DispatchQueue.global().async { [weak self] in
            let url = URL(string:urlString)!
            if let data  = try? Data(contentsOf: url){
                DispatchQueue.main.async() {
                    a.fullImage = UIImage(data: data)
                    a.image = ArtisanListViewController.resizeImage(image: a.fullImage!, targetSize: CGSize(width:50,height:50))
                    self?.artisanTableView.reloadData()
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let newSize = targetSize
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
