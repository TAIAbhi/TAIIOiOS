//
//  LandingViewController.swift
//  Tagabout
//
//  Created by Arun Jangid on 02/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import MapKit

class LandingViewController: ViewController,CLLocationManagerDelegate {

    
    @IBOutlet var shoppingSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var hangoutSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var serviceSwipeGesture: UISwipeGestureRecognizer!
    
    @IBOutlet var shoppingButton: UIButton!
    @IBOutlet var hangoutButton: UIButton!
    @IBOutlet var serviceButton: UIButton!
    
    var locationManager: CLLocationManager = CLLocationManager()
    private lazy var landingRouter = LandingRouter(with: self)

    
    
    static func landingViewController() -> UINavigationController{
        return UINavigationController(rootViewController: LandingViewController.instantiate(fromAppStoryboard: .LandingScene))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.getCurrentLocation()
        self.setupNavigationBar()
        self.addSwipe(shoppingButton)
        self.addSwipe(hangoutButton)
        self.addSwipe(serviceButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getCurrentLocation() {
        
        self.getLocationAccess()
        
    }
    
    func getLocationAccess(){
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func startUpdatingLocation() {
        
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        if locations.last != nil {
            print("Found User's location: \(String(describing: location))")
            print("Latitude: \(location?.coordinate.latitude) Longitude: \(location?.coordinate.longitude)")
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location!) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                    return
                }
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    print(placemark.locality!)
                    print(placemark.name)
                    print(placemark.addressDictionary)
                    print(placemark.subAdministrativeArea)
                    print(placemark.subLocality)
                    print(placemark.administrativeArea!)
                    print(placemark.country!)
                    
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            
            break
        case .notDetermined:  break
        case .denied:  break
        case .restricted: break
            
        }
    }
    
   /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        if locations.last != nil {
            print("Found User's location: \(String(describing: location))")
            print("Latitude: \(location?.coordinate.latitude) Longitude: \(location?.coordinate.longitude)")
            
        }
    }
 */
    

    @objc func hangoutSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.down:
            print("down")
            break
        case UISwipeGestureRecognizerDirection.left:
            print("left")
            break
        case UISwipeGestureRecognizerDirection.right:
            print("right")
            break
        case UISwipeGestureRecognizerDirection.up:
            print("up")
            break
        default: break
            
        }
    }
    
    @objc func shoppingSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.down:
            print("down")
            break
        case UISwipeGestureRecognizerDirection.left:
            print("left")
            break
        case UISwipeGestureRecognizerDirection.right:
            print("right")
            break
        case UISwipeGestureRecognizerDirection.up:
            print("up")
            break
        default: break
            
        }
    }
    @objc func serviceSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.down:
            print("down")
            break
        case UISwipeGestureRecognizerDirection.left:
            print("left")
            break
        case UISwipeGestureRecognizerDirection.right:
            print("right")
            break
        case UISwipeGestureRecognizerDirection.up:
            print("up")
            break
        default: break
            
        }
    }
    
    func addSwipe(_ sender:UIButton) {
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        var selector = #selector(LandingViewController.hangoutSwipeGesture(_:))
        if sender == hangoutButton {
            selector = #selector(LandingViewController.hangoutSwipeGesture(_:))
        }else if sender == shoppingButton{
            selector = #selector(LandingViewController.shoppingSwipeGesture(_:))
        }else{
            selector = #selector(LandingViewController.serviceSwipeGesture(_:))
        }
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: selector)
            gesture.direction = direction
            sender.addGestureRecognizer(gesture)
        }
    }
    
    @IBAction func hangoutaction(_ sender: UIButton) {
        landingRouter.navigateToTabbar()
    }
    
    @IBAction func actionService(_ sender: UIButton) {
        landingRouter.navigateToTabbar()
    }
    @IBAction func actionShopping(_ sender: UIButton) {
        landingRouter.navigateToTabbar()
    }
    
}
