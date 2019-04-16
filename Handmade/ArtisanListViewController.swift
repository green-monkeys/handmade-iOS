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
    var image:UIImage
    var name:String
    var id:String
    var phone:String
    var isSmart:Bool
    init(name:String, image:String) {
        self.name = name
        self.image = ArtisanListViewController.resizeImage(image: UIImage(named:image)!,
                                                           targetSize:CGSize(width:50, height:50))
        self.id = ""
        self.phone = "123-456-7890"
        self.isSmart = true
    }
}
class ArtisanListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var artisanTableView: UITableView!
    @IBOutlet var profileImage: UIImageView!
    var artisans = [Artisan]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.image = ArtisanListViewController.resizeImage(image:UIImage(named: "profile.jpg")!, targetSize:CGSize(width:50, height:50))
        self.profileImage.layer.cornerRadius = 25.0
        self.profileImage.layer.masksToBounds =  true
        self.artisanTableView.delegate =  self
        self.artisanTableView.dataSource =  self
        self.artisans = [Artisan(name:"Patrick Beninga", image:"profile.jpg"),
        Artisan(name:"Patrick Beninga",  image:"profile.jpg"),
        Artisan(name:"Patrick Beninga",  image:"profile.jpg"),
        Artisan(name:"Patrick Beninga",  image:"profile.jpg")]
        self.artisanTableView.backgroundColor = self.view.backgroundColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Artisans"
        // Do any additional setup after loading the view.
    }
    @objc func logOut (){
        self.navigationController?.setViewControllers(
            [self.storyboard!.instantiateViewController(withIdentifier: "rootViewController")],
            animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artisans.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artisanCell") as! ArtisanCell
        cell.profileImage.image = self.artisans[indexPath.row].image
        cell.ArtisanName.text = self.artisans[indexPath.row].name
        cell.profileImage.layer.cornerRadius = 25.0
        cell.profileImage.layer.masksToBounds =  true
        let bgView = UIView()
        bgView.backgroundColor = self.view.backgroundColor
        cell.selectedBackgroundView = bgView
        print("did an image thing")
        
        return cell
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
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
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
