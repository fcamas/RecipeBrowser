//
//  MealViewModel.swift
//  RecipeBrowser
//
//  Created by FredyCamas on 7/13/24.
//

import Foundation

@MainActor
class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var batchOfTen: [Meal] = []
    @Published var loadedMealsCount: Int = 0
    
    @Published var savedDetailMeal: [MealDetails] = [] {
        didSet {
            saveMealsLocally()
        }
    }
    
    private let mealDetailViewModel = MealDetailViewModel()
    private let savedDetailMealKey = "SavedDetailMeals" // Define your UserDefaults key here
    
    func fetchMeals() async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let mealResponse = try JSONDecoder().decode([String: [Meal]].self, from: data)
            if let meals = mealResponse["meals"] {
                self.meals = meals.sorted { $0.strMeal < $1.strMeal }
                loadNextBatch()
            }
        } catch {
            print("Failed to fetch meals: \(error.localizedDescription)")
        }
    }
    
    func loadNextBatch() {
        let batchSize = 10
        let currentCount = self.loadedMealsCount
        let remainingCount = meals.count - currentCount
        
        if remainingCount > 0 {
            let endIndex = min(currentCount + batchSize, meals.count)
            self.batchOfTen = Array(meals[currentCount..<endIndex]).reversed()
            self.loadedMealsCount = endIndex
        } else {
            self.loadedMealsCount = 0
        }
    }
    
    func deleteMealFromBatch(with idMeal: String) {
        if let index = batchOfTen.firstIndex(where: { $0.idMeal == idMeal }) {
            batchOfTen.remove(at: index)
        }
    }
    
    func deleteMeal(withId id: String) {
        if let index = savedDetailMeal.firstIndex(where: { $0.idMeal == id }) {
            savedDetailMeal.remove(at: index)
            saveMealsLocally()
        }
    }
    
    func saveMeal(_ mealId: String) {
        // Check if the mealId is already saved
        if savedDetailMeal.contains(where: { $0.idMeal == mealId }) {
            return // Meal already saved, no need to fetch again
        }
        
        Task {
            await mealDetailViewModel.fetchMealDetails(id: mealId)
            if let mealDetail = mealDetailViewModel.mealDetail {
                self.savedDetailMeal.append(mealDetail)
            }
        }
        saveMealsLocally()
    }
    
    private func saveMealsLocally() {
        do {
            let data = try JSONEncoder().encode(savedDetailMeal)
            UserDefaults.standard.set(data, forKey: savedDetailMealKey)
        } catch {
            print("Failed to encode savedDetailMeal: \(error.localizedDescription)")
        }
    }
    
    func loadSavedMeals() {
        if let data = UserDefaults.standard.data(forKey: savedDetailMealKey) {
            do {
                let meals = try JSONDecoder().decode([MealDetails].self, from: data)
                self.savedDetailMeal = meals
            } catch {
                print("Failed to decode savedDetailMeal: \(error.localizedDescription)")
            }
        }
    }
    
}

@MainActor
class MealDetailViewModel: ObservableObject {
    @Published var mealDetail: MealDetails?
    
    func fetchMealDetails(id: String) async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let mealDetailResponse = try JSONDecoder().decode([String: [MealDetails]].self, from: data)
            if let mealDetail = mealDetailResponse["meals"]?.first {
                self.mealDetail = mealDetail
            }
        } catch {
            print("Failed to fetch meal details: \(error.localizedDescription)")
        }
    }
}
