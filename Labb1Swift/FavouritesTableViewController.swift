//
//  FavouritesTableViewController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 28/02/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
    
    var favouriteIDs : [Int] = []
    var favouriteName : [String] = []
    var compare = false
    var compareID = 0
    var compareName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if let array = UserDefaults.standard.object(forKey: "savedFoodIDs") as? [Int] {
            favouriteIDs = array
            for _ in 1...favouriteIDs.count {
                favouriteName.append("Loading...")
            }
            
        }
    
        
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        if let array = UserDefaults.standard.object(forKey: "savedFoodIDs") as? [Int] {
            favouriteIDs = array
            tableView.reloadData()
            }
            
        }


    
    func getFoodName(foodID : Int, index: Int) {
        let urlString = "http://matapi.se/foodstuff/\(foodID)"
        if let safeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string : safeUrlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request){(data: Data?, response: URLResponse?, error: Error?) in
                if let actualData = data {
                    let jsonOptions = JSONSerialization.ReadingOptions()
                    do {
                        if let parsed = try JSONSerialization.jsonObject(with: actualData, options: jsonOptions) as? [String:Any] {
                            
                            //print(parsed)
                            
                            if let name = parsed["name"] as? String {
                                DispatchQueue.main.async {
                                    self.favouriteName[index] = name
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteIDs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath)
        
        getFoodName(foodID: favouriteIDs[indexPath.row], index: indexPath.row)
       
        cell.textLabel?.text = favouriteName[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if compare {
            performSegue(withIdentifier: "compareSegue", sender: self)
            
        } else {
            performSegue(withIdentifier: "discoSegue", sender: self)
        }
    }
    

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if compare {
            let resultDestination = segue.destination as! CompareViewController
            resultDestination.compare1 = favouriteIDs[(tableView.indexPathForSelectedRow?.row)!]
            resultDestination.compareName1 = favouriteName[(tableView.indexPathForSelectedRow?.row)!]
            resultDestination.compare2 = compareID
            resultDestination.compareName2 = compareName
        } else {
            let resultDestination = segue.destination as! ResultViewController
            let id : Int = (tableView.indexPathForSelectedRow?.row)!
            resultDestination.foodID = favouriteIDs[id]
            resultDestination.name = favouriteName[id]
            
        }
        
        
    }


}
