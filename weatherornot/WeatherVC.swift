//
//  ViewController.swift
//  weatherornot
//
//  Created by Emre Dogan on 13/10/2017.
//  Copyright © 2017 Emre Dogan. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import DropDown

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {
    
    let defaults = UserDefaults.standard
    
    let colorFieldKeyConstant = "colorFieldKeyName"
    let veggyColorKeyConstant = "veggyColorKeyName"
    
    var veggyColor = ""
    
    
 
    let dropDown = DropDown()
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentTempLbl: UILabel!
    
    @IBOutlet weak var locationBtn: UIButton!
    
    let yourAttributes : [String: Any] = [
        NSFontAttributeName : UIFont(name: "Avenir", size: 17.0)!,
        NSForegroundColorAttributeName : UIColor.white,
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    
    
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    
    @IBOutlet weak var topColor: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var forecast: Forecast!
    
    var forecasts = [Forecast]()
    
    var currentWeather: CurrentWeather!
    
    @IBOutlet weak var colorButton: UIButton!
    
    
    @IBAction func colorAction(_ sender: Any) {
        
        dropDown.show()
        
    }
    
    @IBOutlet weak var vegetableIcon: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WeatherVC.imageTapped(gesture:)))
        
        // add it to the image view;
        vegetableIcon.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        vegetableIcon.isUserInteractionEnabled = true
        
        mainView.backgroundColor = UIColor.init(hex: "DCDCDC")
        dropDown.anchorView = colorButton
        dropDown.dataSource = ["Tomato", "Carrot", "Beetroot","Eggplant","ChiliPepper","Corn","Radish","Onion","Cabbage", "Default"]
        
        dropDown.show()
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if item == "Tomato" {
                
                self.veggyColor = "ff6347"
                
                self.topColor.backgroundColor = UIColor(hex: "ff6347")
                
                
                self.vegetableIcon.image = UIImage(named: "tomato")
                
                self.colorButton.setTitle("Tomato",for: .normal)
                
                self.tableView.reloadData()
            } else if item == "Carrot" {
                
                self.veggyColor = "EB8921"
                
                
                
                self.topColor.backgroundColor =  UIColor(hex: "EB8921")
                
                self.vegetableIcon.image = UIImage(named: "carrot")
                
                self.colorButton.setTitle("Carrot",for: .normal)

                
               
            } else if item == "Beetroot" {
                
                
                self.veggyColor = "673f45"
                
                self.topColor.backgroundColor = UIColor(hex: "673f45")
                
                self.vegetableIcon.image = UIImage(named: "beetroot")
                
                self.colorButton.setTitle("Beetroot",for: .normal)
                
            } else if item == "Default" {
                
                self.veggyColor = "88a95b"
                
                self.topColor.backgroundColor = UIColor(hex: "88a95b")
                self.vegetableIcon.image = UIImage(named: "veggy")
                
                self.colorButton.setTitle("Choose your veggy",for: .normal)
                
            }
            
            else if item == "Eggplant" {
                
                self.veggyColor = "2B0B30"
                
                self.topColor.backgroundColor = UIColor(hex: "2B0B30")
                self.vegetableIcon.image = UIImage(named: "eggplant")
                
                self.colorButton.setTitle("Eggplant",for: .normal)
                
            }
            
            else if item == "Corn" {
                
                self.veggyColor = "E9B200"
                
                self.topColor.backgroundColor = UIColor(hex: "E9B200")
                self.vegetableIcon.image = UIImage(named: "corn")
                
                self.colorButton.setTitle("Corn",for: .normal)
                
            }
            
            else if item == "ChiliPepper" {
                
                self.veggyColor = "C11B17"
                
                self.topColor.backgroundColor = UIColor(hex: "C11B17")
                self.vegetableIcon.image = UIImage(named: "chilipepper")
                
                self.colorButton.setTitle("ChiliPepper",for: .normal)
                
            }
            
            else if item == "Radish" {
                
                self.veggyColor = "D44E80"
                
                self.topColor.backgroundColor = UIColor(hex: "D44E80")
                self.vegetableIcon.image = UIImage(named: "radish")
                
                self.colorButton.setTitle("Radish",for: .normal)
                
            }
            
            else if item == "Onion" {
                
                self.veggyColor = "9e8a61"
                
                self.topColor.backgroundColor = UIColor(hex: "9e8a61")
                self.vegetableIcon.image = UIImage(named: "onion")
                
                self.colorButton.setTitle("Onion",for: .normal)
                
            }
            
            else if item == "Cabbage" {
                
                self.veggyColor = "49573F"
                
                self.topColor.backgroundColor = UIColor(hex: "49573F")
                self.vegetableIcon.image = UIImage(named: "cabbage")
                
                self.colorButton.setTitle("Cabbage",for: .normal)
                
            }
            
            self.defaults.setValue(self.colorButton.currentTitle, forKey: self.colorFieldKeyConstant)
            self.defaults.setValue(self.veggyColor, forKey: self.veggyColorKeyConstant)



        }
        
       
        
        if let textFieldValue = defaults.string(forKey: self.colorFieldKeyConstant) {
            colorButton.setTitle(textFieldValue, for: .normal)
            vegetableIcon.image = UIImage(named: "\(textFieldValue.lowercased())")
            
            
        }
        
        if let veggyColorValue = defaults.string(forKey: self.veggyColorKeyConstant) {
            self.topColor.backgroundColor = UIColor(hex: veggyColorValue)
        }
        

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopMonitoringSignificantLocationChanges()
        
        
        
       
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
        
        self.tableView.backgroundColor = UIColor(hex: "e5ecdc")
        
        
        print("emredogan")
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     //   locationAuthStatus()
        
        newLocation()
        locationManager.requestWhenInUseAuthorization()
        
        
        
    }
    
    
    func newLocation() {
        
         print("newLoc\(CHECK_LOCATION)")
        
        if CHECK_LOCATION == "1" {
            
            print("newLoc")
            
            currentWeather.downloadWeatherDetails {
                
                
                
                
                self.downloadForecastDate {
                    self.updateMainUI()
                }
                
                self.tableView.reloadData()
            }
            
            
            
        }
        
        
        
        
        
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            //Here you can initiate your new ViewController
            
            dropDown.show()
            
        }
    }
    
    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            print("emredogan4")
            
            currentLocation = locationManager.location
            
            
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            print("emre: \(Location.sharedInstance.latitude)")
            
            currentWeather.downloadWeatherDetails {
                
                
                
                
                self.downloadForecastDate {
                    self.updateMainUI()
                }
            }
            print("emre\(currentLocation.coordinate.latitude)")
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            // locationAuthStatus()
        }
        
        
            }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            print("doganemre")
            locationAuthStatus()
            
            break
        case .authorizedAlways:
            print("doganemre")
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }

    }


    
    func downloadForecastDate(completed: @escaping DownloadComplete) {
        
        let forecastURL = URL(string: FORECAST_URL)!
        Alamofire.request(forecastURL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary <String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    self.forecasts.removeAll()
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        
                        
                        self.forecasts.append(forecast)
                        print(obj)
                        
                 
                    }
               //     self.forecasts.remove(at: 0)
               //     self.forecasts.remove(at: 1)
                    self.forecasts.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: 0)))
                    self.tableView.reloadData()
                }
            }
            
             completed()
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            let forecast = forecasts[indexPath.row]
            
        
            cell.configureCell(forecast: forecast)
        
            
            
             return cell
        } else {
            
            
            
            return WeatherCell()
        }
        
        
       
    }
    
    func updateMainUI() {
        
        print(currentWeather._cityName)
        
        dateLbl.text = currentWeather.date
        currentTempLbl.text = "\(forTailingZero(temp: currentWeather.currentTemp))°C"
        
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationBtn.setTitle(currentWeather.cityName, for: .normal)
        
        let attributeString = NSMutableAttributedString(string: "\(currentWeather.cityName)",
                                                        attributes: yourAttributes)
        locationBtn.setAttributedTitle(attributeString, for: .normal)
        
        
        
        currentWeatherImage.image = UIImage(named: "\((currentWeatherTypeLabel.text)!)")
        
        
        
        
        
    }
    
    func forTailingZero(temp: Double) -> String{
        var tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    
    
    

    

}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}






