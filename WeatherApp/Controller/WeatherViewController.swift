//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Jieun Bae on 1/1/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var Todo: UIButton!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var day: UILabel!

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weather: UILabel!
    
    @IBOutlet weak var temperature: UILabel!



        let apiKey = "dfc718b2b7203cf289059ccfc9ad2f59"
    
        //default value
        var lat = 70.344533
        var lon = 50.33322
        var activityIndicator: NVActivityIndicatorView!
        let locationManager = CLLocationManager()

        override func viewDidLoad()
        
        {
        super.viewDidLoad()
       
        let indicatorSize: CGFloat = 60
            
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)

        locationManager.requestWhenInUseAuthorization()

        //asks for location
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled())
        
            {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            }

        }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    
        {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON
            {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value
            
                {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                self.place.text = jsonResponse["name"].stringValue
                self.weatherImage.image = UIImage(named: iconName)
                self.weather.text = jsonWeather["main"].stringValue
                self.temperature.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.day.text = dateFormatter.string(from: date)

                
                }
            }
        
        self.locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }


}
