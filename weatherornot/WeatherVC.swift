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
    
    let dropDown = DropDown()
    
    @IBOutlet var mainView: UIView!
    
    
    
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentTempLbl: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    
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
        dropDown.dataSource = ["Tomato", "Carrot", "Beetroot", "Default"]
        
        dropDown.show()
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if item == "Tomato" {
                self.topColor.backgroundColor = UIColor(hex: "ff6347")
                
                
                self.vegetableIcon.image = UIImage(named: "tomato")
                
                self.colorButton.setTitle("Tomato",for: .normal)
                
                self.tableView.reloadData()
            } else if item == "Carrot" {
                
                self.topColor.backgroundColor =  UIColor(hex: "EB8921")
                
                self.vegetableIcon.image = UIImage(named: "carrot")
                
                self.colorButton.setTitle("Carrot",for: .normal)

                
               
            } else if item == "Beetroot" {
                
                
                self.topColor.backgroundColor = UIColor(hex: "673f45")
                
                self.vegetableIcon.image = UIImage(named: "beetroot")
                
                self.colorButton.setTitle("Beetroot",for: .normal)
                
            } else if item == "Default" {
                
                self.topColor.backgroundColor = UIColor(hex: "88a95b")
                self.vegetableIcon.image = UIImage(named: "veggy")
                
                self.colorButton.setTitle("Choose your veggy",for: .normal)
                
            }
        }
        

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopMonitoringSignificantLocationChanges()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
        
        self.tableView.backgroundColor = UIColor(hex: "e5ecdc")
        
        
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
        
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
            locationAuthStatus()
        }
    }
    
    func downloadForecastDate(completed: @escaping DownloadComplete) {
        
        let forecastURL = URL(string: FORECAST_URL)!
        Alamofire.request(forecastURL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary <String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
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
        locationLbl.text = currentWeather.cityName
        
        
        
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




