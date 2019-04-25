
import Foundation

class Item {
    let id:String
    let imageUrl:String
    let title:String
    let price: Double
    let shippingCost:Double
    let zipcode:Int
    var inWishList:Bool
    private let conditionId:String
    let viewItemUrl:String
    
    
    init(id: String,
         imageUrl: String,
         title: String,
         price: Double,
         shippingCost: Double,
         zipcode: Int,
         conditionId: String,
         viewItemUrl: String,
         inWishList: Bool = false) {
        self.id = id
        self.imageUrl = imageUrl
        self.title = title
        self.price = price
        self.shippingCost = shippingCost
        self.zipcode = zipcode
        self.conditionId = conditionId
        self.inWishList = inWishList
        self.viewItemUrl = viewItemUrl
    }
    
    var condition: String {
        get{
            switch conditionId {
            case "1000":
                return "NEW"
            case _ where ["2000", "2500"].contains(conditionId):
                return "REFURBISHED"
            case _ where ["3000", "4000", "5000", "6000"].contains(conditionId):
                return "USED"
            default:
                return "NA"
            }
        }
    }
}
