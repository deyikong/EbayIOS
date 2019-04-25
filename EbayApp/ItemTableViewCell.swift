
import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var thumbnailView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var shippingLabel: UILabel!
    @IBOutlet var zipcodeLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var wishHeart: WishHeart!
    
    var hideWishButton = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        wishHeart?.isHidden = hideWishButton
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
