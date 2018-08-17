//
//  LandingViewController.swift
//  Tagabout
//
//  Created by Arun Jangid on 02/08/18.
//  Copyright © 2018 Tagabout. All rights reserved.
//

import UIKit
import MapKit
import DropDown

class LandingViewController: ViewController,CLLocationManagerDelegate {

    
    @IBOutlet var shoppingSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var hangoutSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var serviceSwipeGesture: UISwipeGestureRecognizer!
    
    @IBOutlet weak var suburbButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var shoppingCOunt: UILabel!
    @IBOutlet var shoppingButton: UIButton!
    @IBOutlet var hangoutButton: UIButton!
    @IBOutlet var serviceButton: UIButton!
    
    @IBOutlet weak var servicesCount: UILabel!
    @IBOutlet weak var hangoutCount: UILabel!
    var hangoutDatasource = [CategoryCountData]()
    var servicesDatasource = [CategoryCountData]()
    var shoppingDatasource = [CategoryCountData]()
    var subUrbDropDown = [BindFilter]()
    
    var cityDatasource = [City]()
    var bindFilterCategoriesDatasource = [BindFilter]()
    var categoryCountDatasource = [CategoryCountData]()
    var currentBindFilter : BindFilter?
    var currentCity : City?
    var currentPlacemark:CLPlacemark?
    var currentLocation : CLLocationCoordinate2D?
    
    var locationManager: CLLocationManager = CLLocationManager()
    private lazy var landingRouter = LandingRouter(with: self)
    private lazy var landingInteractor = LandingInteractor()

    
    
    static func landingViewController() -> UINavigationController{
        return UINavigationController(rootViewController: LandingViewController.instantiate(fromAppStoryboard: .LandingScene))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        self.setupNavigationBar()
        self.addSwipe(shoppingButton)
        self.addSwipe(hangoutButton)
        self.addSwipe(serviceButton)
        
        landingInteractor.fetchCity { (success) in
            self.cityDatasource = success
            self.getCurrentLocation()
        }
    }
    
    func fetcCategories(){
        if self.currentPlacemark != nil, let city = self.cityDatasource.filter({ $0.cityName! == self.currentPlacemark?.locality! }).first{
            self.currentCity = city
            self.landingInteractor.fetchCategories(forPlacemark: self.currentPlacemark!, forCity: city, withSuccessHandler: { (bindFilterCategories) in
                    self.bindFilterCategoriesDatasource = bindFilterCategories
                    self.fetchCategoriesWithCount()
            })
        }
    }
    
    func fetchCategoriesWithCount(){
        
            if let bindFilter = self.bindFilterCategoriesDatasource.filter( { $0.isSelected! == true }).first, let city = self.currentCity{
                self.subUrbDropDown = self.bindFilterCategoriesDatasource.filter( { $0.cityId! == city.cityId!})
                self.suburbButton.setTitle("\(bindFilter.ddText!)", for: .normal)
                self.fetchCategories(forbindFilter: bindFilter, city: city)
            }
    }
    
    
    func fetchCategories(forbindFilter bindFilter:BindFilter?, city:City){
        
        self.landingInteractor.fetchSectionsCategoryWithCount(forBindFilter: bindFilter, forCity: city) { (success) in
            self.categoryCountDatasource = success
            self.hangoutDatasource = self.categoryCountDatasource.filter( {$0.catId!  == 1})
            self.servicesDatasource = self.categoryCountDatasource.filter( {$0.catId!  == 2})
            self.shoppingDatasource = self.categoryCountDatasource.filter( {$0.catId!  == 3})
            threadOnMain {
                self.refreshView()
            }
        }
    }
    
    func refreshView(){
        hangoutCount.isHidden = hangoutDatasource.count < 0
        servicesCount.isHidden = servicesDatasource.count < 0
        shoppingCOunt.isHidden = shoppingDatasource.count < 0
        hangoutCount.text = "\(hangoutDatasource.count)"
        servicesCount.text = "\(servicesDatasource.count)"
        shoppingCOunt.text = "\(shoppingDatasource.count)"
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

    @IBAction func actionSuburbSelect(_ sender: UIButton) {
        
        guard self.subUrbDropDown.count > 0 else {
            return
        }
        let dropDown = DropDown()
        var datasource = [String]()
        datasource.append("All")
        datasource.append(contentsOf: subUrbDropDown.map({$0.ddText!}))
        dropDown.dataSource = datasource
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.bottomOffset = CGPoint(x: 0, y:(sender.bounds.size.height + 5))
        dropDown.dismissMode = .automatic
        dropDown.show()
        dropDown.anchorView = sender
        dropDown.selectionAction = { index, ddText in
            if let city = self.currentCity {
                if ddText == "All" {
                    self.fetchCategories(forbindFilter: nil, city: city)
                }else{
                    self.fetchCategories(forbindFilter: self.bindFilterCategoriesDatasource.filter( { $0.ddText! == ddText }).first, city: city)
                }
            }
            sender.setTitle(ddText, for: .normal)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        currentLocation = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        if locations.last != nil {
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location!) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                    return
                }
                
                if let placemarks = placemarks , placemarks.count > 0 , let currentPlacemark = placemarks.first{
                    self.currentPlacemark = currentPlacemark
                    if self.cityDatasource.count > 0, let city = self.cityDatasource.filter({ $0.cityName! == self.currentPlacemark?.locality! }).first{
                        self.currentCity = city
                        let cityName = self.currentCity?.cityName
                        self.cityButton.setTitle("  \(cityName!)  ", for: .normal)
                        self.fetcCategories()
                    }
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
        self.userSwipe(forGesture: sender, button: hangoutButton, datasource: hangoutDatasource)
    }
    
    func userSwipe(forGesture sender:UISwipeGestureRecognizer, button:UIButton,datasource:[CategoryCountData]){
        var dropDownDatasource = [String]()
        let dropDown = DropDown()
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.down:
            dropDownDatasource.append("All")
            dropDownDatasource.append(contentsOf: datasource.map({$0.categoryName! + "(\($0.suggCount!))" }))
            break
        case UISwipeGestureRecognizerDirection.left:
            dropDownDatasource.append(contentsOf: datasource.map({$0.categoryName! + "(\($0.suggCount!))" }))
            break
        case UISwipeGestureRecognizerDirection.right:
            dropDownDatasource.append(contentsOf: datasource.map({$0.categoryName! + "(\($0.suggCount!))" }))
            break
        case UISwipeGestureRecognizerDirection.up:
            dropDownDatasource.append(contentsOf: datasource.map({$0.categoryName! + "(\($0.suggCount!))" }))
            break
        default: break
        }
        dropDown.dataSource = dropDownDatasource
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.bottomOffset = CGPoint(x: 0, y:(button.bounds.size.height + 5))
        dropDown.dismissMode = .automatic
        dropDown.show()
        dropDown.anchorView = button
        dropDown.selectionAction = { index, ddText in
//            Selected City and Subarea, categoryId, SubCategoryId
        }
    }
    
    @objc func shoppingSwipeGesture(_ sender: UISwipeGestureRecognizer) {
       self.userSwipe(forGesture: sender, button: shoppingButton, datasource: shoppingDatasource)
    }
    @objc func serviceSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        self.userSwipe(forGesture: sender, button: serviceButton, datasource: servicesDatasource)
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
    @IBAction func mydetailsClicked(_ sender: UIButton) {
        landingRouter.navigateToTabbarMydetails()
    }
    
}
