import UIKit

protocol UpdateWishListDelegate:AnyObject{
    func updateItemStatus(_ index: Int, remove: Bool)
}
class WishHeart: UIButton {
    // Images
    let checkedImage = UIImage(named: "wishListFilled")! as UIImage
    let uncheckedImage = UIImage(named: "wishListEmpty")! as UIImage
    var index = 0
    
    weak var delegate: UpdateWishListDelegate?
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
            if oldValue == !isChecked{
                delegate?.updateItemStatus(index, remove: oldValue)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
