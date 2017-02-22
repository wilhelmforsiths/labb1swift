//
//  ViewController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 16/02/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit

var foundNutrients : [food] = []

class ViewController: UIViewController {
    
    @IBOutlet weak var wordEntered: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ultimate Nutrition Finder 5000"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        searchForFood()
    }
    
    func searchForFood() {
        let searchWord : String = wordEntered.text!
        let urlString = "http://matapi.se/foodstuff?query=\(searchWord)"
        
        if let safeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string : safeUrlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request){(data: Data?, response: URLResponse?, error: Error?) in
                if let actualData = data {
                    let jsonOptions = JSONSerialization.ReadingOptions()
                    do {
                        if let parsed = try JSONSerialization.jsonObject(with: actualData, options: jsonOptions) as? [[String:Any]] {
                            
                            DispatchQueue.main.async {
                                self.doParse(dictionaries: parsed)
                                self.performSegue(withIdentifier: "segue", sender: self)
                                
                            }
                            
                        }
                    } catch let parseError {
                        //                        NSLog("Failed to parse JSON: \(parseError)")
                    }
                } else {
                    NSLog("No data received")
                }
            }
            task.resume()
            
        }
        
        
        
    }
    
    func doParse(dictionaries: [[String:Any]]) {
        var foods : [food] = []
        
        for item in dictionaries {
            let foundFood : food = food(number: item["number"] as! Int, name: item["name"] as! String)
            foods.append(foundFood)
        }
        
        foundNutrients = foods
        
    }
}

