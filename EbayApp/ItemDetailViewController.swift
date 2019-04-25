import UIKit
protocol UpdateEachItemWishList {
    func updateItemStatus()
    func shareOnFacebook()
}
class ItemDetailViewController: UITabBarController, UpdateEachItemWishList {

    var item:Item?
    override func viewDidLoad() {
        super.viewDidLoad()
        for tabController in self.viewControllers!{
            if var hasItemController = tabController as? HasItem{
            hasItemController.item = self.item
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func updateItemStatus() {
        print("start")
        self.item!.inWishList = !self.item!.inWishList
        let fbShareButton = UIBarButtonItem(image: UIImage(named: "facebook")! as UIImage, style: .plain, target: self, action: #selector(shareOnFacebook))
        let wishListImage = self.item!.inWishList ? (UIImage(named: "wishListFilled")! as UIImage) : (UIImage(named: "wishListEmpty")! as UIImage)
        
        let updateWishListButton = UIBarButtonItem(image: wishListImage, style: .plain, target: self, action: #selector(updateItemStatus))
        self.navigationItem.rightBarButtonItems = [updateWishListButton, fbShareButton]
        print("hi")
    }
    
    @objc internal func shareOnFacebook() {
        guard let url = URL(string: "https://www.facebook.com/sharer/sharer.php?u=" + self.item!.viewItemUrl) else { return }
        UIApplication.shared.open(url)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
