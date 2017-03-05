//
//  ResultViewController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 16/02/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var foodID : Int = 0
    var protein : Float?
    var carbohydrates : Float?
    var fat : Float?
    var kcal : Float?
    var name : String = ""
    
    var party : Bool = true
    var favourite : Bool = false
    
    var dynamicAnimator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var stopPartyButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discoBall: UIImageView!

    @IBOutlet weak var kCalLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var healthyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFoodInfo()
        favourite = isFoodFavourite()
        if favourite {
            saveButton.setTitle("Ta bort från favoriter", for: .normal)
        }
    }
    
    func getFoodInfo() {
    let urlString = "http://matapi.se/foodstuff/\(foodID)"
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
                            self.kcal = kcalValue!
                            self.protein = proteinValue!
                            self.carbohydrates = carbohydratesValue!
                            self.fat = fatValue!

                            
                            DispatchQueue.main.async {
                                self.refreshGUI()
                                
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
    func refreshGUI() {
        let foodFormater = GraphFoodFormatter()
        kCalLabel.text = "\(kcal!) kcal/100g"
        carbLabel.text = "\(carbohydrates!) g/100g"
        proteinLabel.text = "\(protein!) g/100g"
        fatLabel.text = "\(fat!) g/100g"
        healthyLabel.text = "\(foodFormater.getHealthScore(kcal: Int(kcal!), protein: Int(protein!), fat: Int(fat!), carbs: Int(carbohydrates!)))/5"
        navigationBar.title = "\(name)"
        
        if party {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.view.backgroundColor = UIColor.green
            }) {
                finished in
                UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    if self.party {
                        self.view.backgroundColor = UIColor.red
                    }
                    
                }) {
                    finished in
                    self.refreshGUI()
                }
            }
        }
        
        
    }

   
   
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if favourite {
            deleteSavedNutrition()
            saveButton.setTitle("Spara näringsvärde", for: .normal)
            favourite = false
        } else {
            saveNutrition()
            saveButton.setTitle("Ta bort från favoriter", for: .normal)
            favourite = true
        }

    }
    
    
    func saveNutrition() {
        var savedFoodIDs : [Int] = []
        if let food = UserDefaults.standard.object(forKey: "savedFoodIDs") as? [Int] {
            savedFoodIDs = food
        } else {
            savedFoodIDs = []
        }
        
        savedFoodIDs.append(foodID)
        UserDefaults.standard.set(savedFoodIDs, forKey: "savedFoodIDs")
    }
    
    func deleteSavedNutrition() {
        var savedFoodIDs : [Int] = []
        if let food = UserDefaults.standard.object(forKey: "savedFoodIDs") as? [Int] {
            savedFoodIDs = food
        } else {
            savedFoodIDs = [foodID]
        }
        
        savedFoodIDs = savedFoodIDs.filter{$0 != foodID}
        UserDefaults.standard.set(savedFoodIDs, forKey: "savedFoodIDs")

    }
    
    func isFoodFavourite() -> Bool {
        if let favourites = UserDefaults.standard.object(forKey: "savedFoodIDs") as? [Int] {
            for fav in favourites {
                if foodID == fav {
                    return true
                }
            }

        }
        
        
        return false
        
    }
    @IBAction func KaPling(_ sender: UIBarButtonItem) {
        print("Ka-Pling")
    }
    
    @IBAction func stopTheParty(_ sender: UIButton) {
        UIView.animate(withDuration: 2.5, animations: {
            self.view.backgroundColor = UIColor.black
        })
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [discoBall])
        dynamicAnimator.addBehavior(gravity)
        
        party = false
        stopPartyButton.isHidden = true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "compareSegue2" {
            if let resultDestination = segue.destination as? FavouritesTableViewController {
                resultDestination.compare = true
                resultDestination.compareID = foodID
                resultDestination.compareName = name
            }
        }
        
        if segue.identifier == "photoSegue" {
            if let resultDestination = segue.destination as? PhotoViewController {
                resultDestination.id = foodID
            }
        }

    }
    
    
}
