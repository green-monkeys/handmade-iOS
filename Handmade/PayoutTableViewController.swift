//
//  PayoutTableViewController.swift
//  Handmade
//
//  Created by Patrick Beninga on 5/15/19.
//  Copyright © 2019 Patrick Beninga. All rights reserved.
//

import UIKit

class PayoutTableViewCell: UITableViewCell {

    @IBOutlet var whoLabel: UILabel!
    @IBOutlet var paidLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
}
class Payout{
    var time:String
    var cga:String
    var artisan:String
    var paid:Bool
    var amount:String
    var id:Int
    init(_ p:Bool, _ t:String, _ c:String, _ a:String, _ amt:String, id:Int){
        paid = p
        time = t
        cga = c
        artisan = a
        amount = amt
        self.id = id
    }
    
}
class PayoutTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var payouts = [Payout]()
    var forCGA:Bool!
    var artisan:Artisan!
    var overlay = UIView()
    var delegate:AppDelegate!
    var payoutAmtToAdd:Double?
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.delegate = UIApplication.shared.delegate as? AppDelegate
        if(self.delegate.cga != nil){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add payout", style: .plain, target: self, action: #selector(self.addPayout))
        }
        overlay.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        overlay.frame = self.view.frame
        self.view.addSubview(overlay)
        var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = overlay.center
        overlay.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.overlay.isHidden = false
        self.navigationItem.title = self.artisan.name
        self.refreshPayouts()
    }
    
    func refreshPayouts(){
        let urlString = "http://capstone406.herokuapp.com/artisan/\(artisan.Id!)"
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
                guard let data = data else {return}
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: [])
                    guard let dataJson = jsonResponse as? [String: [String:Any]] else {return }
                    guard let x = dataJson["data"] else {return}
                    print("HEREEEE \(x)")
                    let payouts = x["payouts"] as! [NSDictionary]
                    self.payouts.removeAll()
                    for payout in payouts{
                        let paid = (payout["paid"] as! Bool)
                        self.payouts.append(Payout(paid, payout["t"] as! String, self.delegate!.cga?.name ?? "Patrick Beninga", self.artisan.name, "$" + String(describing:  payout["amount"]!), id: payout["id"]! as! Int))
                        print()
                    }
                    self.overlay.isHidden = true
                    self.tableView.reloadData()
                }catch let parsingError{
                    print("here")
                    print("Error", parsingError)
                    print("here")
                }
            }
            
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.delegate.cga == nil){
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        let urlString = "http://capstone406.herokuapp.com/payout/\(payouts[indexPath.row].id)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        var dict = [String:Bool]()
        dict["paid"] = !payouts[indexPath.row].paid
        self.overlay.isHidden = false
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            print(url)
            let task = URLSession.shared.dataTask(with: request){
                (data, response, error) -> Void in
                if(error != nil){
                    print("OOGA BOOGA WE GOT AN ERROR")
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    self.overlay.isHidden = true
                    self.refreshPayouts()
                }
            }
            task.resume()
            
        }catch {
            print(error.localizedDescription)
        }
    }
    @objc func addPayout(){
        let alert = UIAlertController(title: "Add payout", message: "How much do you need to pay?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.makePayment(Double(alert.textFields![0].text!) ?? nil)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))

        self.present(alert, animated: true, completion: nil)
        
    }
    func makePayment(_ amt:Double?){
        
        let urlString = "http://capstone406.herokuapp.com/payout"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var dict = [String:Double]()
        dict["cgaId"] = Double(self.delegate.cga!.id)!
        dict["artisanId"] = Double(self.artisan.Id!)!
        if(amt == nil){
            return
        }
        dict["amount"] = amt!
        self.overlay.isHidden = false
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            print(url)
            let task = URLSession.shared.dataTask(with: request){
                (data, response, error) -> Void in
                if(error != nil){
                    print("OOGA BOOGA WE GOT AN ERROR")
                    print(error)
                    return
                }
                print(String(data: data!, encoding: .utf8))
                DispatchQueue.main.async {
                    self.overlay.isHidden = true
                    self.refreshPayouts()
                }
            }
            task.resume()
            
        }catch {
            print(error.localizedDescription)
        }
    }
            
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payoutCell") as! PayoutTableViewCell
        cell.paidLabel.text = payouts[indexPath.row].paid ? "Paid" : "Unpaid"
        cell.dateLabel.text = convertToReadableDate(date: getDateFromString(dateStr: (payouts[indexPath.row].time)) ?? Date())
        cell.whoLabel.text = "Paid by: " + payouts[indexPath.row].cga
        cell.amountLabel.text = payouts[indexPath.row].amount
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.payouts.count
    }
    
    func convertToReadableDate(date: Date) -> String {
        let df: DateFormatter = DateFormatter()
        df.dateStyle = DateFormatter.Style.short
        df.timeStyle = DateFormatter.Style.medium
        return df.string(from: date)
        
    }

    func getDateFromString(dateStr: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yy-MM-dd'T'HH:mm:ss.SSSZ"
        let result = df.date(from: dateStr)
        print(result)
        return result
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
