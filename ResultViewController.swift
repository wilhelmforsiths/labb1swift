//
//  ResultViewController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 16/02/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var foodID : Int?
    var protein : Float?
    var carbohydrates : Float?
    var fat : Float?
    var kcal : Float?
    
    @IBOutlet weak var textField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getFoodInfo()

    }
    
    func getFoodInfo() {
    let urlString = "http://matapi.se/foodstuff/\(foodID!)"
    var kcalValue : Float?
    var proteinValue : Float?
    var carbohydratesValue : Float?
    var fatValue : Float?
    if let safeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
    let url = URL(string : safeUrlString) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){(data: Data?, response: URLResponse?, error: Error?) in
            if let actualData = data {
                let jsonOptions = JSONSerialization.ReadingOptions()
                do {
                    if let parsed = try JSONSerialization.jsonObject(with: actualData, options: jsonOptions) as? [String:Any] {
                        
                        //print(parsed)
                        
                        if let dictionary = parsed["nutrientValues"] as? [String:Any] {
                            kcalValue = dictionary["energyKcal"] as? Float
                            proteinValue = dictionary["protein"] as? Float
                            carbohydratesValue = dictionary["carbohydrates"] as? Float
                            fatValue = dictionary["fat"] as? Float
                            
                            DispatchQueue.main.async {
                                self.kcal = kcalValue!
                                self.protein = proteinValue
                                self.carbohydrates = carbohydratesValue
                                self.fat = fatValue
                                print("\(self.fat)")
                                print("\(self.protein)")
                                print("\(self.carbohydrates)")
                                print("\(self.kcal)")
                                
                                
                                
                            }
                        } else {
                            print("Couldn't parse NutrientValues")
                        }
                        
                    }
                } catch let parseError {
                    NSLog("Failed to parse JSON: \(parseError)")
                }
            } else {
                NSLog("No data received")
            }
            
        }
        task.resume()
        
    }
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
