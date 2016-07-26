//
//  SettingsViewController.swift
//  ATMFinder
//
//  Created by Steven Li on 21/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showBranchSwitch: UISwitch!
    @IBOutlet weak var showATMSwitch: UISwitch!
    @IBOutlet weak var showGroupSwitch: UISwitch!
    
    private let cities: Array<(cityName: String, longitude: Double, latitude: Double)> = [("Auckland", 36.8485, 174.7633), ("Wellington", 41.2865, 174.7762), ("Chrischurch", 43.5321, 172.6362)]
    
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"
        
        getCurrentLocation()
        setupControls()
        
        //set up view
        activityIndicator.hidden = true

        
    }
    
    func setupControls() {
        
        //location picker view
        let locationPickerView = UIPickerView()
        
        locationPickerView.dataSource = self
        locationPickerView.delegate = self
        locationPickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SettingsViewController.donePicker))
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        locationTextField.inputView = locationPickerView
        locationTextField.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.delegate = self
            
        }
    }
    
    func donePicker() {
        locationTextField.endEditing(true)
    }
    
    func updateUserLocation(location: CLLocation) {
        self.location = location
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: NSError?) in
            if let placemarks = placemarks {
                self.locationTextField.text = placemarks.first!.locality!
            }
            
        }
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row].cityName
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        locationTextField.text = cities[row].cityName
        
        self.location = CLLocation(latitude: cities[row].latitude, longitude: cities[row].longitude)
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
}

extension SettingsViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        updateUserLocation(locations.first!)
    }
}