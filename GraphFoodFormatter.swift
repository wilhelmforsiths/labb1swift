//
//  GraphFoodFormatter.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 04/03/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import Foundation

class GraphFoodFormatter {
    func getFoodCallback(index: Int, fullFoods: [FoodFull]) -> Int {
        
        switch index {
        case 0:
            return (fullFoods[0].kcal / 10)
        case 1:
            return (fullFoods[1].kcal / 10)
        case 2:
            return fullFoods[0].protein
        case 3:
            return fullFoods[1].protein
        case 4:
            return fullFoods[0].fat
        case 5:
            return fullFoods[1].fat
        case 6:
            return fullFoods[0].carbs
        case 7:
            return fullFoods[1].carbs
        default:
            return 0
        }
        
    }
    
    func getHealthScore(kcal: Int, protein: Int, fat: Int, carbs: Int) -> Int {
        var score = 1
        if kcal < 150 {
            score += 1
        }
        if protein > 18 {
            score += 1
        }
        if fat < 20 {
            score += 1
        }
        if fat < 5 {
            score += 1
        }
        return score
    }
}
