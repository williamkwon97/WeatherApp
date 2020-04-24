//
//  ViewController.swift
//  uk669_assignment7
//
//  Created by William Kwon on 3/20/20.
//  Copyright © 2020 William Kwon. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    @IBOutlet weak var TempLabel: UILabel!
      @IBOutlet weak var weatherImageView: UIImageView!
      @IBOutlet weak var cloudcoverLabel: UILabel!
      @IBOutlet weak var HumidityLabel: UILabel!
      @IBOutlet weak var PressureLabel: UILabel!
      @IBOutlet weak var PrecipitationLabel: UILabel!
      @IBOutlet weak var windLabel: UILabel!

    @IBOutlet weak var errormsgLabel: UILabel!
    @IBOutlet weak var CitySearchBar: UITextField!
    @IBOutlet weak var StateSearchBar: UITextField!
    @IBAction func enterInput(_ sender: UIButton) {
        func displayMyAlertMessage(userMessage:String){

            let myAlert = UIAlertController(title: "Invalid Input", message: userMessage, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
           myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
         if (CitySearchBar.text == "") && (StateSearchBar.text == "") {
            CitySearchBar.layer.borderColor = UIColor.red.cgColor
            StateSearchBar.layer.borderColor = UIColor.red.cgColor
            displayMyAlertMessage(userMessage: "All fields are required")
            return
        }
        
            CitySearchBar.text = CitySearchBar.text?.replacingOccurrences(of: " ", with: "_")
        StateSearchBar.text = StateSearchBar.text?.replacingOccurrences(of: " ", with: "_")
        let city = CitySearchBar.text!
        let state = StateSearchBar.text!
       
        let loc = "\(city),\(state)"
        
     
           let location = loc
          
           guard let url = URL(string:"https://api.worldweatheronline.com/premium/v1/weather.ashx?key=c1000961f636421bb5e52941202104&format=json&q=\(location)") else {return}
           
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
           

          
                      if let data = data, error == nil {
                          do {
                            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                            print(json)
                            
                            if (json.value(forKeyPath: "data.error.msg") != nil){
                                                        DispatchQueue.main.async {
                                            
                                                                        self.errormeesage()
                                                            
                                                        }
                                return print("ther was error")
                                                        }
                           
                       
                            let tempF = json.value(forKeyPath: "data.current_condition.temp_F") as Any
                            let tempC = json.value(forKeyPath: "data.current_condition.temp_C") as Any
                            
                            let humidity = (json.value(forKeyPath: "data.current_condition.humidity") as Any)
                          
                            let windSpeed = (json.value(forKeyPath: "data.current_condition.windspeedMiles") as Any)
                        
                            let windDirection = (json.value(forKeyPath: "data.current_condition.winddir16Point") as Any )
                          
                            let precipInches =
                                (json.value(forKeyPath: "data.current_condition.precipMM") as Any)
                        
                            let pressureInches =
                                                 (json.value(forKeyPath: "data.current_condition.pressure") as  Any)
                                                 
                            let cloudcover =
                                (json.value(forKeyPath: "data.current_condition.cloudcover") as Any)
                            let winddirDegree =
                            (json.value(forKeyPath: "data.current_condition.winddirDegree") as Any)
                            let windspeedKmph =
                            (json.value(forKeyPath: "data.current_condition.windspeedKmph") as Any)

                            let weatherIconUrl = (json.value(forKeyPath: "data.current_condition.weatherIconUrl.value") as Any)
        
                           
                            DispatchQueue.main.async {
                                self.setWeather(tempF: tempF as! NSArray, tempC:tempC as! NSArray,humidity:humidity as! NSArray,windSpeed:windSpeed as! NSArray,windDirection:windDirection as! NSArray, precipInches: precipInches as! NSArray, pressureInches:pressureInches as! NSArray,cloudcover:cloudcover as! NSArray, weatherIconUrl:weatherIconUrl as! NSArray,winddirDegree:winddirDegree as! NSArray,windspeedKmph:windspeedKmph as! NSArray)
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
            

          }
          //MARK SET WEATHER
    func errormeesage (){
        
        errormsgLabel.text = "Current conditions not found"
        weatherImageView.image = nil
        TempLabel.text = ""
        HumidityLabel.text = ""
        PrecipitationLabel.text = ""
        PressureLabel.text = ""
        cloudcoverLabel.text = ""
        windLabel.text = ""
        return
        
    }
    func setWeather(  tempF: NSArray, tempC: NSArray ,humidity:NSArray,windSpeed:NSArray,windDirection:NSArray, precipInches:NSArray, pressureInches:NSArray,cloudcover:NSArray, weatherIconUrl:NSArray,winddirDegree:NSArray,windspeedKmph:NSArray) {

    TempLabel.text = "\(tempC.map({ "\($0)" }).joined(separator: ", "))°C/\(tempF.map({ "\($0)" }).joined(separator: ", "))°F"
        HumidityLabel.text = "\(humidity.map({ "\($0)" }).joined(separator: ", "))%"
        PrecipitationLabel.text = "\(precipInches.map({ "\($0)" }).joined(separator: ", "))mm"
        PressureLabel.text = "\(pressureInches.map({ "\($0)" }).joined(separator: ", "))mbar"
        cloudcoverLabel.text = "\(cloudcover.map({ "\($0)" }).joined(separator: ", "))%"
        
        windLabel.text = "\(windspeedKmph.map({ "\($0)" }).joined(separator: ", "))kmph/\(windSpeed.map({ "\($0)" }).joined(separator: ", "))mph \(windDirection.map({ "\($0)" }).joined(separator: ", "))(\(winddirDegree.map({ "\($0)" }).joined(separator: ", "))°)"
        windLabel.sizeToFit()
        errormsgLabel.text = ""
        
  
        let weatherIcon =  weatherIconUrl.map({ "\($0)" }).joined(separator: ", ")
        print(weatherIcon)
        let trimmed = String(weatherIcon.filter { !" \n\t\r".contains($0) })
        let trimmed1 = trimmed.replacingOccurrences(of: "\"", with: "")
        let trimmed2 = trimmed1.replacingOccurrences(of: "\\(", with: "", options: .regularExpression)
        let trimmed3 = trimmed2.replacingOccurrences(of: "\\)", with: "", options: .regularExpression)
      print(trimmed2)
     
        let weatherUrl: String = trimmed3
        let imageUrl = URL(string: weatherUrl)
     
        let data = try? Data(contentsOf: imageUrl!)
        let image = UIImage(data:data!)
        weatherImageView.image = image
        
              
              
          }
      }
      //MARK: FUNCTIONS
     
        





   

