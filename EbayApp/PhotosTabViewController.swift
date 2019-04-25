
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class PhotosTabViewController: UIViewController, HasItem, UIScrollViewDelegate {
    let baseUrl = "https://hw-09-238502.appspot.com/"

    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in photos " + item!.title)
        self.scrollView.delegate = self
        self.scrollView!.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
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
                let pictures = json["Item"]["PictureURL"].arrayValue.map {$0.stringValue}
                for picture in pictures{
                    Alamofire.request(picture).responseImage { response in
                        if let image = response.result.value {
                            print("image sssss: \(image)")
                            let imgView = UIImageView(frame: CGRect(x:0, y:0,width:self.scrollView.frame.width, height:self.scrollView.frame.height))
                            imgView.image = image
                            self.scrollView.addSubview(imgView)
                        }
                    }
                }

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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageWidth/2)/pageWidth)+1
        // Change the indicator
    }
    
}
