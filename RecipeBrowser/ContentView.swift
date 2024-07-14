//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by FredyCamas on 7/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MealViewModel()
    @State private var deletedMeals: [Meal] = []
    @State private var savedMeals: [Meal] = []
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(Gradient(colors: [.brown.opacity(0.1), .brown.opacity(0.2)]))
            
            if viewModel.batchOfTen.isEmpty {
                Text("Loading...")
                    .foregroundColor(.materialBlueGray)
                    .font(.title)
                    .onAppear {
                        Task {
                            viewModel.loadNextBatch()
                        }
                    }
            } else {
                ForEach(viewModel.batchOfTen) { meal in
                    VStack {
                        MealCardView(meal: meal, onSwipedLeft: {
                            viewModel.deleteMealFromBatch(with: meal.idMeal)
                        }, onSwipedRight: {
                            viewModel.saveMeal(meal.idMeal)
                            viewModel.deleteMealFromBatch(with: meal.idMeal)
                        }).rotationEffect(.degrees(Double(viewModel.batchOfTen.count - 1 - viewModel.batchOfTen.firstIndex(of: meal)!)))
                        
                    }
                }
            }
        }
        .onAppear{
            Task{
                await viewModel.fetchMeals()
            }
        }
    }
}

#Preview {
    ContentView()
}

