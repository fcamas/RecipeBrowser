//
//  MealDetailView.swift
//  RecipeBrowser
//
//  Created by FredyCamas on 7/13/24.
//

import SwiftUI

struct MealDetailView: View {
    let meal: MealDetails
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let url = URL(string: meal.strMealThumb ?? "") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(meal.strMeal)
                    .font(.largeTitle)
                    .padding(.top)
                
                Text("Ingredients")
                    .font(.title2)
                    .padding(.top)
                
                ForEach(0..<meal.ingredients.count, id: \.self) { index in
                    if let ingredient = meal.ingredients[index], let measure = meal.measurements[index] {
                        Text("\(ingredient): \(measure)")
                            .padding(.vertical, 2)
                    }
                }
                
                Text("Instructions")
                    .font(.title2)
                    .padding(.top)
                
                Text(meal.strInstructions ?? "No instructions available")
                    .padding(.top, 5)
            }
            .padding()
        }
        .navigationTitle(meal.strMeal)
    }
}

