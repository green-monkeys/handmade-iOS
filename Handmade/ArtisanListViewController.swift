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
    var Id:String?
    init(name:String, username:String, phone:String?, isSmart:Bool) {
        self.name = name
        self.phone = phone
        self.isSmart = isSmart
        self.username = username
    }
    init(name:String, username:String, phone:String?, isSmart:Bool, Id:String) {
        self.name = name
        self.phone = phone
        self.isSmart = isSmart
        self.username = username
        self.Id = Id
    }
    init(name:String, username:String, phone:String?, isSmart:Bool, localImage:UIImage) {
        self.name = name
        self.phone = phone
        self.isSmart = isSmart
        self.username = username
        self.fullImage = localImage
        self.image = ArtisanListViewController.resizeImage(image: self.fullImage!, targetSize: CGSize(width:50,height:50))
    }
    init(name:String, username:String, phone:String?, isSmart:Bool, localImage:UIImage, id:String) {
        self.name = name
        self.phone = phone
        self.isSmart = isSmart
        self.username = username
        self.fullImage = localImage
        self.image = ArtisanListViewController.resizeImage(image: self.fullImage!, targetSize: CGSize(width:50,height:50))
        self.Id = id
    }
}
class ArtisanListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var artisanTableView: UITableView!
    @IBOutlet var profileImage: UIImageView!
    var artisans = [Artisan]()
    var delegate = UIApplication.shared.delegate as! AppDelegate
    let overlay = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.image = ArtisanListViewController.resizeImage(image:UIImage(named: "profile.jpg")!, targetSize:CGSize(width:80, height:80))//This needs to be changed later
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
        overlay.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        overlay.frame = self.artisanTableView.frame
        self.view.addSubview(overlay)
        var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = overlay.center
        overlay.addSubview(activityIndicator)
        activityIndicator.startAnimating()
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
                self.delegate.cga = nil
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
        self.artisans = []
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
                    if(self.overlay.superview != nil){
                        self.overlay.removeFromSuperview()
                        self.overlay.subviews[0].removeFromSuperview()
                    }
                }
            }
            task.resume()
        }

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: deleteTitle) { (action, indexPath) in
                                                    self.deleteArtisan(row: indexPath.row)
        }
        return [deleteAction]
    }
    func deleteArtisan(row:Int){
        let art = self.artisans.remove(at: row)
        self.artisanTableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        let urlString = "http://capstone406.herokuapp.com/artisan/\(art.Id!)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "Delete"
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) -> Void in
            if(error != nil){
                print("OOGA BOOGA WE GOT AN ERROR")
                print(error)
                return
            }
            DispatchQueue.main.async {
                guard let data = data else {return}
                print(String(data: data, encoding: .utf8))
            }
        }
        task.resume()
    }
    func parseArtisans(data:Data){
        do{
            let jsonResponse = try JSONSerialization.jsonObject(with:
            data, options: [])
            guard let dataJson = jsonResponse as? [String: [[String:Any]]] else {return}
            print(dataJson)
            guard let json = dataJson["data"] else {return}
            print(json)
            for x in json {
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
                let art = Artisan(name: firstName + " " + lastName, username: username, phone:phoneString , isSmart: isSmart, Id:IdString)
                artisans.append(art)
                if(imageURL != nil){
                    ArtisanListViewController.fetchImage(imageURL!, art, cb:self.artisanTableView.reloadData)
                }
            }
        }catch let parsingError{
            print("here")
            print("Error", parsingError)
            print("here")
        }
        
    }
    static func fetchImage(_ urlString: String, _ a:Artisan, cb: @escaping () -> Void){
        print("Download Started")
        DispatchQueue.global().async {
            let url = URL(string:urlString)!
            if let data  = try? Data(contentsOf: url){
                DispatchQueue.main.async() {
                    a.fullImage = UIImage(data: data)
                    a.image = ArtisanListViewController.resizeImage(image: a.fullImage!, targetSize: CGSize(width:50,height:50))
                    cb()
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
