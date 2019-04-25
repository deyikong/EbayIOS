
import UIKit
import CoreLocation
import McPicker
import Toast_Swift
import Alamofire
import SwiftyJSON
import SwiftSpinner


class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var zipcodeBox: UITextField!
    @IBOutlet weak var categoryBox: UITextField!
    @IBOutlet weak var keywordBox: UITextField!
    @IBOutlet weak var customLocationSwitch: UISwitch!
    @IBOutlet weak var distanceBox: UITextField!
    
    @IBOutlet weak var newCheckbox: CheckBox!
    @IBOutlet weak var usedCheckbox: CheckBox!
    @IBOutlet weak var unspecifiedCheckbox: CheckBox!
    @IBOutlet weak var pickupCheckbox: CheckBox!
    @IBOutlet weak var freeShippingCheckbox: CheckBox!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var noItemLabel: UILabel!
    
    
    let locationManager = CLLocationManager()


    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            myTableView.isHidden = true
            searchView.isHidden = false
            print("SEA")
        case 1:
            if WishItems.items.count != 0
            {
                noItemLabel.isHidden = true
                myTableView.isHidden = false
                myTableView.reloadData()
                myTableView.setNeedsLayout()
            }else{
                noItemLabel.isHidden = false
            }
            searchView.isHidden = true
                print("WIS")
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startReceivingLocationChanges()
        keywordBox.delegate = self
        distanceBox.delegate = self
        zipcodeBox.delegate = self
        
        categoryBox.delegate = self
        customLocationSwitch.isOn = false
        customLocationSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        zipcodeBox.isHidden = true
        myTableView.dataSource = self
        myTableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WishItems.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("worrrks")
        let cellIdentifier = "ItemTableViewCellWithoutHeart"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        
        let item  = WishItems.items[indexPath.row]
        
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
        cell.hideWishButton = true
        return cell
    }
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {
            (placemarks, error) -> Void in
            
            if error != nil {
                print("Location Error!")
                return
            }
            
            if let pm = placemarks?.first {
                print("im here")
                self.zipcodeBox.text = pm.postalCode
            } else {
                print("error with data")
            }
        })
    }

    @IBAction func clear(_ sender: UIButton) {
        keywordBox.text = ""
        categoryBox.text = ""
        newCheckbox.isChecked = false
        usedCheckbox.isChecked = false
        unspecifiedCheckbox.isChecked = false
        pickupCheckbox.isChecked = false
        freeShippingCheckbox.isChecked = false
        distanceBox.text = ""
        zipcodeBox.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == categoryBox {
            showCategories()
            return false
        }
        return true
    }
    
    @objc func switchChanged(mySwitch: UISwitch){
        zipcodeBox.isHidden = !mySwitch.isOn
    }
    
    private func validate()->(Bool, String){
        guard let keyword = keywordBox.text, keyword.trimmingCharacters(in: .whitespaces) != "" else {
            return (false, "Keyword Is Mandatory")
        }
        if (customLocationSwitch.isOn)
        {
            guard let zipcode = zipcodeBox.text, zipcode.trimmingCharacters(in: .whitespaces) != "" else {
                return (false, "Zipcode Is Mandatory")
            }
        }
        return (true, "No Error")
    }
    private func showCategories()
    {
        McPicker.show(data: [["All","Art", "Baby", "Books", "Clothing, Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]]) {  [weak self] (selections: [Int : String]) -> Void in
            if let cat  = selections[0] {
                self?.categoryBox.text = cat
            }
        }
    }
    
    private func makeRequest() -> Optional<Dictionary<String, Any>> {
        var category = "-1"
        switch(categoryBox.text)
        {
        case "Art":
            category = "550"
        case "Baby":
            category = "2984"
        case "Books":
            category = "267"
        case "Clothing, Shoes & Accessories":
            category = "11450"
        case "Computers/Tablets & Networking":
            category = "58058"
        case "Health & Beauty":
            category = "26395"
        case "Music":
            category = "11233"
        case "Video Games & Consoles":
            category = "1249"
        default:
            category = "-1"
        }
        if (!customLocationSwitch.isOn)
        {
            startReceivingLocationChanges()
        }
        let parametersData = [
            "pageSize": "50",
            "keywords": keywordBox.text ?? "",
            "conditionNew":newCheckbox.isChecked ? "New" : "",
            "conditionUsed":usedCheckbox.isChecked ? "Used" : "",
            "conditionUnspecified":unspecifiedCheckbox.isChecked ? "Unspecified" : "",
            "categoryId": category,
            "LocalPickupOnly": pickupCheckbox.isChecked ? "localPickup" : "",
            "FreeShippingOnly": freeShippingCheckbox.isChecked ? "freeShipping": "",
            "distance": distanceBox.text?.isEmpty ?? false ? "10" : distanceBox.text!,
            "zipCode": zipcodeBox.text?.isEmpty ?? false ? "77001" : zipcodeBox.text!
            ] as [String : Any]

        print(parametersData)
        return parametersData
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let validation = validate()
        if (!validation.0)
        {
            self.view.makeToast(validation.1)
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemTableViewController
        {
            let itemTableViewController = segue.destination as? ItemTableViewController
            
            
            itemTableViewController?.requestData = makeRequest()
            
        }
//        guard let itemTableViewController = segue.destination as? ItemTableViewController
//            else{
//                fatalError("Unexpected destination")
//        }
    }
}

