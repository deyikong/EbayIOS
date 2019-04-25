
import UIKit

class SimilarTabViewController: UIViewController, HasItem {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in similar " + item!.title)
        
        // Do any additional setup after loading the view.
    }
    var item: Item? {
        didSet{
            
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
    
}
