//
//  ViewController.swift
//  EbayApp
//
//  Created by on 4/23/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import CoreLocation
import McPicker
import Toast_Swift

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var zipcodeBox: UITextField!
    @IBOutlet weak var categoryBox: UITextField!
    @IBOutlet weak var keywordBox: UITextField!
    @IBOutlet weak var customLocationSwitch: UISwitch!
    @IBOutlet weak var distanceBox: UITextField!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startReceivingLocationChanges()
        keywordBox.delegate = self
        distanceBox.delegate = self
        zipcodeBox.delegate = self
        
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

    @IBAction func search(_ sender: UIButton) {
        let validation = validate()
        if (!validation.0)
        {
            self.view.makeToast(validation.1)
        }
    }
    @IBAction func clear(_ sender: UIButton) {
        showCategories()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
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
        McPicker.show(data: [["Kevin", "Lauren", "Kibby", "Stella"]]) {  [weak self] (selections: [Int : String]) -> Void in
            if let cat  = selections[0] {
                self?.categoryBox.text = cat
            }
        }
    }
    
    
}

