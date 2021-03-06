//
//  AppDelegate.swift
//  Handmade
//
//  Created by Patrick Beninga on 4/4/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cga:CGA?
    var artisan:Artisan?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return AMZNAuthorizationManager.handleOpen(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func parseCgaFromJSON(data:Data) -> CGA?{
        do{
            print("starting CGA parse")
            print(data.description)
            //here dataResponse received from a network request
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data, options: [])
            print(jsonResponse) //Response resul
            let jsontemp = jsonResponse as? [String: [String:Any]] ?? nil
            if(jsontemp == nil) {
                print("something went wrong here")
                return nil
            }
            else {
            let json = jsontemp!["data"]!
            let imgURL = json["imageUrl"] as? String ?? ""
            
            let cgaRes = CGA(email: json["email"] as! String,
                           firstName: json["first_name"] as! String,
                           lastName: json["last_name"] as! String,
                           Id : String(json["id"] as! Int),
                           imageURL: imgURL,
                           image: nil
                        )
            cga = cgaRes
            print("parsed CGA")
            return cgaRes
            }
        } catch let parsingError {
            print("Error", parsingError)
            return nil
        }

    }


}

