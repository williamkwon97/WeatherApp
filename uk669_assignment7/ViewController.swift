//
//  ViewController.swift
//  uk669_assignment7
//
//  Created by William Kwon on 3/20/20.
//  Copyright © 2020 William Kwon. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var CitySearchBar: UITextField!
    @IBOutlet weak var StateSearchBar: UITextField!
    @IBOutlet weak var CheckConditionButton: UIButton!
   
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cloudcoverLabel: UILabel!
    @IBOutlet weak var HumidityLabel: UILabel!
    @IBOutlet weak var PressureLabel: UILabel!
    @IBOutlet weak var PrecipitationLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    func getWeather(loc: String) {
        super.viewDidLoad()
        guard let url = URL(string:"https://api.worldweatheronline.com/premium/v1/weather.ashx?key=71f187bbe97b495988c165458182610&format=json") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                   if let data = data, error == nil {
                       do {
                           guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {return}
                           guard let weatherDetails = json["weather"] as? [[String : Any]], let weatherMain = json["main"] as? [String : Any], let weatherWind = json["wind"] as? [String : Any], let weatherSystem = json["sys"] as? [String : Any]else {return}
                           let temp = Int(weatherMain["temp"] as? Double ?? 0)
                      
                           let humidity = Int(weatherMain["humidity"] as? Double ?? 0)
                           let windSpeed = Int(weatherWind["speed"] as? Double ?? 0)
                           let windDirection = Int(weatherWind["deg"] as? Double ?? 0)
                          
                           let city = (json["name"] ?? "...")
                           let country = (weatherSystem["country"] ?? "...")
                           DispatchQueue.main.async {
                               self.setWeather(weather: weatherDetails.first?["main"] as? String,  temp: temp, humidity: humidity, windSpeed: windSpeed, windDirection: windDirection, city: city, country: country)
                           }
                       } catch {
                           print("We had an error retriving the weather...")
                       }
                   }
               }
               task.resume()
           
    }
    
    
          override func viewDidLoad() {
              super.viewDidLoad()
              // Do any additional setup after loading the view, typically from a nib.
              getWeather(loc: "Poway")
          }
          //MARK SET WEATHER
          func setWeather(weather: String?, description: String?, temp: Int, humidity: Int, windSpeed: Int, windDirection: Int, low: Int, high: Int, city: Any, country: Any) {
              TempLabel.text = "\(temp)˚"
              HumidityLabel.text = "Humidity: \(humidity)%"
              windLabel.text = "Wind: \(windSpeed) MPH \(compassDirection(heading: Double(windDirection)))"
    
              place.text = "\(city), \(country)"
              let clear = UIColor(red: 0.94901960784, green: 0.94901960784, blue: 0.16470588235, alpha: 1)
              let cloud =  UIColor(red: 0.68235294117, green: 0.83921568627, blue: 0.94509803921, alpha: 1)
              let snow = UIColor(red: 0.52156862745, green: 0.5725490196, blue: 0.61960784313, alpha: 1)
              let fog = UIColor(red: 0.94901960784, green: 0.95294117647, blue: 0.95686274509, alpha: 1)
              let rain = UIColor(red: 0, green: 0.47843137254, blue: 1, alpha: 1)
              let thunder = UIColor(red: 0.95294117647, green: 0.61176470588, blue: 0.07058823529  , alpha: 1)
              switch weather {
              case "Clear":
                  weatherImageView.image = UIImage(named: "Sunny")
                  background.backgroundColor = clear
                  backgroundtwo.backgroundColor = clear
                  scroll.backgroundColor = clear
                  searchButton.setTitleColor(clear, for: .normal)
                  searchBar.textColor = clear
              case "Clouds":
                  weatherImageView.image = UIImage(named: "Cloudy")
                  background.backgroundColor = cloud
                  backgroundtwo.backgroundColor = cloud
                  scroll.backgroundColor = cloud
                  searchButton.setTitleColor(cloud, for: .normal)
                  searchBar.textColor = cloud
              case "Snow":
                  weatherImageView.image = UIImage(named: "Snow")
                  background.backgroundColor = snow
                  backgroundtwo.backgroundColor = snow
                  scroll.backgroundColor = snow
                  searchButton.setTitleColor(snow, for: .normal)
                  searchBar.textColor = snow
              case "Atmosphere":
                  weatherImageView.image = UIImage(named: "Fog")
                  background.backgroundColor = fog
                  backgroundtwo.backgroundColor = fog
                  scroll.backgroundColor = fog
                  searchButton.setTitleColor(fog, for: .normal)
                  searchBar.textColor = fog
              case "Rain":
                  weatherImageView.image = UIImage(named: "Rain")
                  background.backgroundColor = rain
                  backgroundtwo.backgroundColor = rain
                  scroll.backgroundColor = rain
                  searchButton.setTitleColor(rain, for: .normal)
                  searchBar.textColor = rain
              case "Drizzle":
                  weatherImageView.image = UIImage(named: "Rain")
                  background.backgroundColor = rain
                  backgroundtwo.backgroundColor = rain
                  scroll.backgroundColor = rain
                  searchButton.setTitleColor(rain, for: .normal)
                  searchBar.textColor = rain
              case "Thunderstorm":
                  weatherImageView.image = UIImage(named: "Thunder")
                  background.backgroundColor = thunder
                  backgroundtwo.backgroundColor = thunder
                  scroll.backgroundColor = thunder
                  searchButton.setTitleColor(thunder, for: .normal)
                  searchBar.textColor = thunder
              default:
                  weatherImageView.image = UIImage(named: "Cloudy")
                  background.backgroundColor = rain
                  backgroundtwo.backgroundColor = rain
                  scroll.backgroundColor = rain
                  searchButton.setTitleColor(rain, for: .normal)
                  searchBar.textColor = rain
              }
          }
      }
      //MARK: FUNCTIONS
      extension String {
          func capitalizingFirstLetter() -> String {
              return prefix(1).uppercased() + self.lowercased().dropFirst()
          }
      }
      func compassDirection(heading: Double) -> String {
          if heading < 0 { return "" }
          let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
          let index = Int((heading + 22.5) / 45.0) & 7
          return directions[index]
      }



}
   
