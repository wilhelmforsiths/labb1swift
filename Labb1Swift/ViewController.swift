//
//  ViewController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 16/02/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit

var searchedWords : String = ""

class ViewController: UIViewController {

    @IBOutlet weak var wordEntered: UITextField!
    
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onButtonClicked(_ sender: Any) {
        searchedWords = wordEntered.text!
        
    }
}

