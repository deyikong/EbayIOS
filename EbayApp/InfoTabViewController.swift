
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

protocol HasItem {
    var item:Item? { get set }
}
class InfoTabViewController: UIViewController, HasItem, UIScrollViewDelegate, UITableViewDelegate {

    //var item:Item?
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let baseUrl = "https://hw-09-238502.appspot.com/"
    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("in info " + item!.title)
        self.tableView.delegate = self
        self.scrollView!.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
//        for picture in pictures{
//            Alamofire.request(picture).responseImage { response in
//                if let image = response.result.value {
//                    print("image sssss: \(image)")
//                    let imgView = UIImageView(frame: CGRect(x:0, y:0,width:self.scrollView.frame.width, height:self.scrollView.frame.height))
//                    imgView.image = image
//                    self.scrollView.addSubview(imgView)
//                }
//            }
//        }
//        self.pageControl.currentPage = 0
        
    }
    var item: Item? {
        didSet{
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
                    self.pictures = json["Item"]["PictureURL"].arrayValue.map {$0.stringValue}
                    for picture in self.pictures{
                        Alamofire.request(picture).responseImage { response in
                            if let image = response.result.value {
                                print("image sssss: \(image)")
                                let imgView = UIImageView(frame: CGRect(x:0, y:0,width:self.scrollView.frame.width, height:self.scrollView.frame.height))
                                imgView.image = image
                                self.scrollView.addSubview(imgView)
                            }
                        }
                    }
                    self.scrollView.delegate = self
                    self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
                    self.pageControl.currentPage = 0
                    self.scrollView.isPagingEnabled=true
                    
                    self.titleLabel.text = json["Item"]["Title"].stringValue
                    self.priceLabel.text = json["Item"]["CurrentPrice"]["Value"].stringValue
                    var i = 0
                    for nameValueList in json["Item"]["ItemSpecifics"]["NameValueList"].arrayValue{
                       
                        self.keyValueDic[nameValueList["Name"].stringValue] = nameValueList["Value"][0].stringValue
                        let tableViewCell = UITableViewCell()
                        let label1 = UILabel()
                        label1.text = nameValueList["Name"].stringValue
                        let label2 = UILabel()
                        label2.text = nameValueList["Value"][0].stringValue
                        tableViewCell.addSubview(label1)
                        tableViewCell.addSubview(label2)
                        self.tableView.insertSubview(tableViewCell, at: i)
                        i = i + 1
                    }
                    
                    //self.tableView.dataSource = keyValueDic
                }
            }
            
        }
    }
    var keyValueDic = [String:String]()
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


