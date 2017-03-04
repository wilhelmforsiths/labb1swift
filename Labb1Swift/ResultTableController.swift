//
//  ResultTableController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 20/02/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit

class ResultTableController: UITableViewController {
    
    var foodResultArray : [Food] = []
    var kcal : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()

    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func shorterString(food1 : Food, food2 : Food) -> Bool {
        return food1.name.characters.count < food2.name.characters.count
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foodResultArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodTableViewCell
        
        let nutrientsInList : [Food] = foodResultArray.sorted(by: shorterString)

        cell.name = nutrientsInList[indexPath.row].name
        cell.number = nutrientsInList[indexPath.row].number
        cell.nameLabel.text = "\(nutrientsInList[indexPath.row].name)"
        getKcalValue(cell: cell)
        if cell.kcal != 0 {
            cell.kcalLabel.text = "\(cell.kcal) kcal"
        } else {
            cell.kcalLabel.text = "Loading..."
        }
        

        return cell
    }
    
    func getKcalValue(cell : FoodTableViewCell) {
        
        
        let urlString = "http://matapi.se/foodstuff/\(cell.number!)"
        var kcalValue : Float?
        if let safeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string : safeUrlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request){(data: Data?, response: URLResponse?, error: Error?) in
                if let actualData = data {
                    let jsonOptions = JSONSerialization.ReadingOptions()
                    do {
                        if let parsed = try JSONSerialization.jsonObject(with: actualData, options: jsonOptions) as? [String:Any] {
                            
                            if let dictionary = parsed["nutrientValues"] as? [String:Any] {
                                kcalValue = dictionary["energyKcal"] as? Float
                                
                                DispatchQueue.main.async {
                                    cell.kcal = Int(kcalValue!)
                                }
                            } else {
                                print("Couldn't parse NutrientValues")
                                cell.kcal = 0
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let cell = (sender as? FoodTableViewCell) {
                if segue.identifier == "segue2" {
                    if let resultDestination = segue.destination as? ResultViewController {
                        resultDestination.foodID = cell.number!
                        resultDestination.name = cell.name!
                }
                
            }
        }

    }
    

}
