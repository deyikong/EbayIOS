//
//  ItemTableViewCell.swift
//  EbayApp
//
//  Created by Deyi Kong on 4/23/19.
//  Copyright © 2019 Deyi Kong. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var thumbnailView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var shippingLabel: UILabel!
    @IBOutlet var zipcodeLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var wishHeart: WishHeart!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
