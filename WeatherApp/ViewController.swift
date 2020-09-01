//
//  ViewController.swift
//  WeatherApp
//
//  Created by Пользователь on 25.08.2020.
//  Copyright © 2020 Raisat Ramazanova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))&appid=0eb6b62fd8a750a7ac88d10a0494f71c"        
        let url = URL(string: urlString)
        var locationName: String?
        var temp: Double?
        var errorHasOccured: Bool = false
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]              
                if let error = json["message"] {
                    errorHasOccured = true
                }
                
                locationName = json["name"] as? String
                if let main = json["main"] {
                    temp = main["temp"] as? Double
                    temp = round(temp! - 273)
                }
                
                DispatchQueue.main.async {
                    
                    if errorHasOccured {                        
                        self.cityLabel.text = "Error has occured"
                        self.tempLabel.isHidden = true
                    } else {
                        self.cityLabel.text = locationName
                        self.tempLabel.text = "\(temp!)"                   
                        self.tempLabel.isHidden = false
                    }
                }                              
            }
            catch let jsonEError {
                print(jsonEError)
            }
        }       
        task.resume()
    }
}
