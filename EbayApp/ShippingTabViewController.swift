//
//  InfoTabViewController.swift
//  EbayApp
//
//  Created by Deyi Kong on 4/24/19.
//  Copyright © 2019 Deyi Kong. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ShippingTabViewController: UIViewController, HasItem {
    
    @IBOutlet var storeName: UILabel!
    @IBOutlet var feedbackScore: UILabel!
    @IBOutlet var popularity: UILabel!
    @IBOutlet var feedbackStar: UILabel!
    @IBOutlet var shippingCost: UILabel!
    @IBOutlet var globalShipping: UILabel!
    @IBOutlet var handlingTime: UILabel!
    @IBOutlet var policy: UILabel!
    @IBOutlet var returnMode: UILabel!
    @IBOutlet var shippingCostPaidBy: UILabel!
    @IBOutlet var returnWithin: UILabel!
    
    let baseUrl = "https://hw-09-238502.appspot.com/"
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in shipping " + item!.title)
        Alamofire.request(baseUrl+"detail", method: .get, parameters: ["id": self.item!.id]).responseJSON {
            response in
            //
            //                switch response.result {
            //                case .success(let data):
            //                    print("scu")
            //                case .failure(let error):
            //                    print("Request failed with error: \(error)")
            //                }
            print(response.result)
            if response.result.value != nil{
                let json = JSON(response.result.value!)
                self.storeName.text = json["Item"]["Storefront"]["StoreName"].stringValue
                self.feedbackScore.text = json["Item"]["Seller"]["FeedbackScore"].stringValue
                self.popularity.text = json["Item"]["Seller"]["PositiveFeedbackPercent"].stringValue
                self.feedbackStar.text = json["Item"]["Seller"]["Purple"].stringValue
                self.shippingCost.text = String(self.item!.shippingCost)
                self.globalShipping.text = json["GlobalShipping"].boolValue ? "YES" : "NO"
                self.handlingTime.text = json["HandlingTime"].stringValue
                self.policy.text = json["ReturnPolicy"]["ReturnsAccepted"].stringValue
                self.returnMode.text = json["ReturnMode"].stringValue
                self.returnWithin.text = json["ReturnWithin"].stringValue
                self.shippingCostPaidBy.text = json["ShippingCostPaidBy"].stringValue
                //self.tableView.dataSource = keyValueDic
            }
        }
    }
    var item: Item? 
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
