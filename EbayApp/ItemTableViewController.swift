//
//  ItemTableViewController.swift
//  EbayApp
//
//  Created by Deyi Kong on 4/24/19.
//  Copyright © 2019 Deyi Kong. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftSpinner
import SwiftyJSON
import Toast_Swift

class ItemTableViewController: UITableViewController, UpdateWishListDelegate {
    func updateItemStatus(_ index: Int, remove: Bool) {
        print("\(index): \(remove)")
        if remove
        {
            self.view.makeToast(items[index].title + " was removed from the wishList", duration: 3.0, position: .bottom)
        }else{
            self.view.makeToast(items[index].title + " was added to the wishList", duration: 3.0, position: .bottom)
        }
        
        let pathIndex = IndexPath(row: index, section: 0)
        items[index].inWishList = !remove
        print("in wish list: \(items[index].inWishList)")
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [pathIndex], with: .automatic)
        self.tableView.endUpdates();
    }
    

    private var items = [Item]()
    let baseUrl = "https://hw-09-238502.appspot.com/"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//
//
//        items.append(Item(imageUrl: "http://thumbs2.ebaystatic.com/m/mJwglyXSeI6Hkwyk71hKVEQ/140.jpg", title: "OEM Apple Lightning to 3.5mm Headphone Jack Adapter Genuine iPhone 7 8 X Plus ", price: 10.8, shippingCost: 2.3, zipcode: 77000, conditionId: "2000"))
    }

    // MARK: - Table view data source

    var requestData: Optional<Dictionary<String, Any>> = nil{
        didSet {
            SwiftSpinner.show("Searching...")
            Alamofire.request(baseUrl+"list", method: .get, parameters: requestData).responseJSON {
                response in
                if response.result.value != nil{
                    let json = JSON(response.result.value!)
                    for item in json["findItemsAdvancedResponse"][0]["searchResult"][0]["item"].arrayValue{
                        let item = Item(
                            imageUrl: item["galleryURL"][0].stringValue,
                            title: item["title"][0].stringValue,
                            price: Double(truncating: item["sellingStatus"][0]["currentPrice"][0]["__value__"].numberValue),
                            shippingCost: Double(truncating: item["shippingInfo"][0]["shippingServiceCost"][0]["__value__"].numberValue),
                            zipcode: Int(truncating: item["postalCode"][0].numberValue),
                            conditionId: item["condition"][0]["conditionId"].stringValue)
                        let newIndexPath = IndexPath(row: self.items.count, section: 0)
                        self.items.append(item)
                        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                        print(".")
                    }
                    SwiftSpinner.hide()
                }
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ItemTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }

        let item  = self.items[indexPath.row]

        print(self.items.count)
        cell.wishHeart.isChecked = item.inWishList
        cell.titleLabel.text = item.title
        Alamofire.request(item.imageUrl).responseImage { response in
            if let image = response.result.value {
                print("image downloaded: \(image)")
                cell.thumbnailView.image = image
            }
        }
        cell.priceLabel.text = "$" + String(item.price)
        if item.shippingCost == 0{
        cell.shippingLabel.text = "FREE SHIPPING"
        }else{
            cell.shippingLabel.text = String(item.shippingCost)
        }
        cell.zipcodeLabel.text = String(item.zipcode)
        cell.conditionLabel.text = item.condition
        cell.wishHeart.index = indexPath.row
        cell.wishHeart.delegate = self
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(items[indexPath.row].title)
    }
    //    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? ViewController {
//            self.items = sourceViewController.items
//        }
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
