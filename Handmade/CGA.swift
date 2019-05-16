//
//  CGA.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/17/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

class CGA: NSObject {
    var email:String
    var firstName:String
    var lastName:String
    var imageUrl:String?
    var image:UIImage?
    var name:String
    let id:String
    init(email:String, firstName:String, lastName:String, Id:String, imageURL:String? ,image:UIImage?){
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.imageUrl = imageURL
        self.image = image
        self.id = Id
        self.name = firstName + " " + lastName
        
    }
}
