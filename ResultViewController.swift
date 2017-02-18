//
//  ResultViewController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 16/02/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit

//Gör till TableView och skicka vidare till en ytterliga viewController

class ResultViewController: UIViewController {

    @IBOutlet weak var enteredString: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enteredString.text = searchedWords

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
