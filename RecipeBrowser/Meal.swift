//
//  Meal.swift
//  RecipeBrowser
//
//  Created by FredyCamas on 7/13/24.
//

import Foundation

struct Meal: Identifiable, Decodable, Equatable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?
    
    var id: String { idMeal }
}

struct MealDetails: Codable, Identifiable {
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?
    let strInstructions: String?
    let ingredients: [String?]
    let measurements: [String?]
    
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strInstructions, strMealThumb
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        
        // Decode ingredients
        var ingredientsArray: [String] = []
        for index in 1...5 {
            if let ingredient = try container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: "strIngredient\(index)")!),
               !ingredient.isEmpty {
                ingredientsArray.append(ingredient)
            }
        }
        ingredients = ingredientsArray
        
        // Decode measurements
        var measurementsArray: [String] = []
        for index in 1...5 {
            if let measure = try container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: "strMeasure\(index)")!),
               !measure.isEmpty {
                measurementsArray.append(measure)
            }
        }
        measurements = measurementsArray
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(idMeal, forKey: .idMeal)
        try container.encode(strMeal, forKey: .strMeal)
        try container.encode(strInstructions, forKey: .strInstructions)
        try container.encodeIfPresent(strMealThumb, forKey: .strMealThumb)
        
        // Encode ingredients
        for (index, ingredient) in ingredients.enumerated() {
            try container.encode(ingredient, forKey: CodingKeys(rawValue: "strIngredient\(index + 1)")!)
        }
        
        // Encode measurements
        for (index, measure) in measurements.enumerated() {
            try container.encode(measure, forKey: CodingKeys(rawValue: "strMeasure\(index + 1)")!)
        }
    }
}
