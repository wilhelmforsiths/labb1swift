//
//  ResultTableController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 20/02/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit

class ResultTableController: UITableViewController {
    
    var kcal : Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func shorterString(food1 : Food, food2 : Food) -> Bool {
        return food1.name.characters.count < food2.name.characters.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foundNutrients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodTableViewCell
        
        let nutrientsInList : [Food] = foundNutrients.sorted(by: shorterString)

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
        
        //Lyckas inte hämta någon data. Lös varför!
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = (sender as? FoodTableViewCell) {
            if segue.identifier == "segue2" {
                let resultDestination = segue.destination as! ResultViewController
                resultDestination.foodID = cell.number
                resultDestination.name = cell.name
            }
        }

    }
    

}
