//
//  FoodFull.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 04/03/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import Foundation

struct FoodFull {
    var name : String
    var iD : Int
    var kcal : Int
    var protein : Int
    var carbs : Int
    var fat : Int
    var healthScore : Int
    
    init(name: String, iD: Int, kcal: Int, protein: Int, carbs: Int, fat: Int) {
        self.name = name
        self.iD = iD
        self.kcal = kcal
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        let foodFormatter = GraphFoodFormatter()
        self.healthScore = foodFormatter.getHealthScore(kcal: kcal, protein: protein, fat: fat, carbs: carbs)
    }
}
