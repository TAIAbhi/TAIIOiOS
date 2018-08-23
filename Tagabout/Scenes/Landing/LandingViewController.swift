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
    var dismissView:((SuggestionFilter,[CategoryCountData],[CategoryCountData],[CategoryCountData]) ->())!
    var myDetailsHandler:(() ->())!
    var downDismisHandler:((SuggestionFilter,[CategoryCountData],[CategoryCountData],[CategoryCountData]) ->())!
    var rightDismissHandler:((Int) -> ())!
    
    static func landingViewController() -> LandingViewController{
        return  LandingViewController.instantiate(fromAppStoryboard: .LandingScene)
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
        currentBindFilter = bindFilter
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
        if let hangoutItem = hangoutDatasource.filter({ $0.categoryName == "0"}).first, let count = hangoutItem.suggCount{
            hangoutCount.text = "\(count)"
        }
        
        if let serviceItem = servicesDatasource.filter({ $0.categoryName == "0"}).first, let count = serviceItem.suggCount{
            servicesCount.text = "\(count)"
        }
        if let shoppingItem = shoppingDatasource.filter({ $0.categoryName == "0"}).first, let count = shoppingItem.suggCount{
            shoppingCOunt.text = "\(count)"
        }
        
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
    @objc func shoppingSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        self.userSwipe(forGesture: sender, button: shoppingButton, datasource: shoppingDatasource)
    }
    @objc func serviceSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        self.userSwipe(forGesture: sender, button: serviceButton, datasource: servicesDatasource)
    }
    
    func userSwipe(forGesture sender:UISwipeGestureRecognizer, button:UIButton,datasource:[CategoryCountData]){
        var dropDownDatasource = [String]()
        if  sender.direction == UISwipeGestureRecognizerDirection.right{
            if self.rightDismissHandler != nil, let cityId = self.currentCity?.cityId {
                self.rightDismissHandler(cityId)
            }
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        let dropDown = DropDown()
        dropDownDatasource.append(contentsOf: datasource.map({$0.categoryName! == "0" ? "All" + " (\($0.suggCount!))" : $0.categoryName! + " (\($0.suggCount!))"}))
        
        dropDown.dataSource = dropDownDatasource
        dropDown.shadowRadius = 1
        dropDown.shadowOpacity = 0.2
        dropDown.bottomOffset = CGPoint(x: 0, y:(button.bounds.size.height + 5))
        dropDown.dismissMode = .automatic
        
        dropDown.anchorView = button
        
        
        dropDown.show()
        dropDown.selectionAction = { index, ddText in
            switch sender.direction {
            case UISwipeGestureRecognizerDirection.down:
                
                if self.downDismisHandler != nil {
                    var filter =  self.suggestionFilter(button.tag)
                    let selectedCategories = datasource[index]
                    filter.catId = selectedCategories.catId
                    filter.subCatId = selectedCategories.subCatId
                    filter.pageNumber = 1
                    filter.isLocal = selectedCategories.isLocal
                    self.downDismisHandler(filter,self.hangoutDatasource,self.servicesDatasource,self.shoppingDatasource)
                }
                self.dismiss(animated: true, completion: nil)
                break
            case UISwipeGestureRecognizerDirection.left:
                
                break
            case UISwipeGestureRecognizerDirection.right:
                if self.rightDismissHandler != nil, let cityId = self.currentCity?.cityId {
                    self.rightDismissHandler(cityId)
                }
                self.dismiss(animated: true, completion: nil)
                break
            case UISwipeGestureRecognizerDirection.up:
                
                break
            default: break
            }
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
        if dismissView != nil {
//            dismissView(suggestionFilter(1),hangoutDatasource,servicesDatasource,shoppingDatasource)
        }
        dismiss(animated: true) {
            
        }
    }
    
    @IBAction func actionService(_ sender: UIButton) {
        if dismissView != nil {
//            dismissView(suggestionFilter(2),hangoutDatasource,servicesDatasource,shoppingDatasource)
        }
        dismiss(animated: true) {
            
        }
    }
    @IBAction func actionShopping(_ sender: UIButton) {
        if dismissView != nil {
//            dismissView(suggestionFilter(3),hangoutDatasource,servicesDatasource,shoppingDatasource)
        }
        dismiss(animated: true) {
            
        }
    }
    @IBAction func mydetailsClicked(_ sender: UIButton) {
        if myDetailsHandler != nil {
            myDetailsHandler()
        }
        
    }
    
    func suggestionFilter(_ catId:Int) -> SuggestionFilter{
        var filter = SuggestionFilter()
        filter.catId = catId
        filter.cityId = currentCity?.cityId
        filter.areaShortCode = currentBindFilter?.ddValue
        filter.contactId = APIGateway.shared.loginData?.loginDetail?.contactId
        return filter
    }
    
    
    
}
