//
//  SettingsView.swift
//  RecipeBrowser
//
//  Created by FredyCamas on 7/13/24.
//

import SwiftUI

struct Favorite: View {
    @StateObject private var viewModel = MealViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.savedDetailMeal) { meal in
                    NavigationLink(destination: MealDetailView(meal: meal)) {
                        HStack {
                            if let url = URL(string: meal.strMealThumb ?? "") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipped()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            
                            Text(meal.strMeal)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let mealIdToDelete = viewModel.savedDetailMeal[index].idMeal
                        viewModel.deleteMeal(withId: mealIdToDelete)
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadSavedMeals()
            }
        }
    }
}

#Preview {
    Favorite()
}
