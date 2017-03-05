//
//  CompareViewController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 03/03/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit
import GraphKit

class CompareViewController: UIViewController, GKBarGraphDataSource {
    
    var compare1 : Int = 0
    var compareName1: String = ""
    var compare2 : Int = 0
    var compareName2 : String = ""
    var barLabels = ["kCal", "kCal", "Prot", "Prot", "Fett", "Fett", "Carb", "Carb"]
    var fullFoods : [FoodFull] = []
    var graph : GKBarGraph?
    
    @IBOutlet weak var compareName1Label: UILabel!
    @IBOutlet weak var compareName2Label: UILabel!
    @IBOutlet weak var kCalLabel1: UILabel!
    @IBOutlet weak var kCalLabel2: UILabel!
    @IBOutlet weak var proteinLabel1: UILabel!
    @IBOutlet weak var proteinLabel2: UILabel!
    @IBOutlet weak var fatLabel1: UILabel!
    @IBOutlet weak var fatLabel2: UILabel!
    @IBOutlet weak var carbsLabel1: UILabel!
    @IBOutlet weak var carbsLabel2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createFoodFull(foodID: compare1, name: compareName1)
        createFoodFull(foodID: compare2, name: compareName2)
        
        self.title = "Jämför livsmedel"
        compareName1Label.text = compareName1
        compareName2Label.text = compareName2
        
        graph = GKBarGraph(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 200))
        graph!.dataSource = self
        view.addSubview(graph!)
        graph?.draw()
    }
    override func viewDidAppear(_ animated: Bool) {
        graph?.draw()
    }

    public func numberOfBars() -> Int {
        return 8
    }
    
    public func valueForBar(at index: Int) -> NSNumber! {
        let graphFormatter = GraphFoodFormatter()
        if fullFoods.count > 1 {
            return NSNumber.init(value: graphFormatter.getFoodCallback(index: index, fullFoods: fullFoods))
        }
            return 0
    }
    
    
    
    public func colorForBar(at index: Int) -> UIColor! {
        if index % 2 == 0 {
            return UIColor.red
        } else {
            return UIColor.blue
        }
    }
    
    
   
    
    public func animationDurationForBar(at index: Int) -> CFTimeInterval {
        return 2.0
    }
    
    
    public func titleForBar(at index: Int) -> String! {
        return barLabels[index]
    }
    
    func setUpLabelNumbers() {
        if fullFoods.count > 1 {
            kCalLabel1.text = "\(fullFoods[0].kcal) kcal/100g"
            kCalLabel2.text = "\(fullFoods[1].kcal) kcal/100g"
            proteinLabel1.text = "\(fullFoods[0].protein)%"
            proteinLabel2.text = "\(fullFoods[1].protein)%"
            fatLabel1.text = "\(fullFoods[0].fat)%"
            fatLabel2.text = "\(fullFoods[1].fat)%"
            carbsLabel1.text = "\(fullFoods[0].carbs)%"
            carbsLabel2.text = "\(fullFoods[1].carbs)%"
        }
        
    }
    
    func createFoodFull(foodID: Int, name: String) {
        let urlString = "http://matapi.se/foodstuff/\(foodID)"
            if let safeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string : safeUrlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request){(data: Data?, response: URLResponse?, error: Error?) in
                if let actualData = data {
                    let jsonOptions = JSONSerialization.ReadingOptions()
                    do {
                        if let parsed = try JSONSerialization.jsonObject(with: actualData, options: jsonOptions) as? [String:Any] {
                            
                            
                            if let dictionary = parsed["nutrientValues"] as? [String:Any] {
                                let kcalValue = dictionary["energyKcal"] as? Float
                                let proteinValue = dictionary["protein"] as? Float
                                let carbohydratesValue = dictionary["carbohydrates"] as? Float
                                let fatValue = dictionary["fat"] as? Float
                                
                                let foodfull = FoodFull(name: name, iD: foodID, kcal: Int(kcalValue!), protein: Int(proteinValue!), carbs: Int(carbohydratesValue!), fat: Int(fatValue!))
                                
                                DispatchQueue.main.async {
                                    
                                    self.fullFoods.append(foodfull)
                                    if foodID == self.compare2 {
                                        self.setUpLabelNumbers()
                                        self.graph!.draw()
                                    }
                                    
                                    
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
