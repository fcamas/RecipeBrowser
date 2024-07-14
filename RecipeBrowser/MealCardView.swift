//
//  MealCardView.swift
//  RecipeBrowser
//
//  Created by FredyCamas on 7/13/24.
//

import SwiftUI

struct MealCardView: View {
    let meal: Meal
    
    var onSwipedLeft: (() -> Void)?
    var onSwipedRight: (() -> Void)?
    
    @State private var isShowingDetails = false
    @State private var offset: CGSize = .zero
    @StateObject private var viewModel = MealDetailViewModel()
    
    private let swipeThreshold: CGFloat = 200
    
    var body: some View {
        ZStack {
            frontView
                .opacity(isShowingDetails ? 0 : 1)
                .rotation3DEffect(.degrees(isShowingDetails ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            
            detailView
                .opacity(isShowingDetails ? 1 : 0)
                .rotation3DEffect(.degrees(isShowingDetails ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 300, height: 500)
        .opacity(3 - abs(offset.width) / Double(swipeThreshold) * 3)
        .rotationEffect(.degrees(offset.width / 20.0))
        .offset(CGSize(width: offset.width, height: 0))
        .gesture(DragGesture()
            .onChanged { gesture in
                offset.width = gesture.translation.width
            }
            .onEnded { gesture in
                if gesture.translation.width > swipeThreshold {
                    onSwipedRight?()
                } else if gesture.translation.width < -swipeThreshold {
                    onSwipedLeft?()
                } else {
                    withAnimation {
                        offset = .zero
                    }
                }
            }
        )
        .onTapGesture {
            withAnimation {
                isShowingDetails.toggle()
                if isShowingDetails {
                    Task {
                        await viewModel.fetchMealDetails(id: meal.idMeal)
                    }
                }
            }
        }
    }
    
    private var frontView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.blue.opacity(0.8))
                .shadow(color: .black, radius: 4, x: -2, y: 2)
            
            VStack(spacing: 20) {
                Text(meal.strMeal)
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white)
                
                AsyncImage(url: URL(string: meal.strMealThumb ?? "")!) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .shadow(radius: 5)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .shadow(radius: 5)
                    @unknown default:
                        ProgressView()
                    }
                }
                
                // Show "Saving" or "Deleting" text based on swipe direction
                Text(offset.width > 0 ? "Saving" : "Deleting")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(offset.width > 0 ? .green : .red) // Change color based on swipe direction
                    .opacity(abs(offset.width) / swipeThreshold)
            }
            .padding()
        }
    }
    
    private var detailView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.green.opacity(0.8))
                .shadow(color: .black, radius: 4, x: -2, y: 2)
            
            ScrollView {
                VStack(spacing: 20) {
                    if let mealDetail = viewModel.mealDetail {
                        Text(mealDetail.strMeal)
                            .font(.largeTitle)
                            .padding()
                        
                        Text("Ingredients")
                            .font(.headline)
                            .padding(.top)
                        
                        ForEach(Array(zip(mealDetail.ingredients, mealDetail.measurements)), id: \.0) { ingredient, measurement in
                            Text("\(String(describing: ingredient)): \(String(describing: measurement))")
                                .padding(.horizontal)
                        }
                        
                        Text("Instructions")
                            .font(.headline)
                            .padding(.top)
                        
                        Text(mealDetail.strInstructions ?? "")
                            .padding()
                    } else {
                        ProgressView()
                            .onAppear {
                                Task {
                                    await viewModel.fetchMealDetails(id: meal.idMeal)
                                }
                            }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    MealCardView(meal: Meal(
        idMeal: "52772",
        strMeal: "Spaghetti Carbonara",
        strMealThumb: "https://www.themealdb.com/images/media/meals/xxrxux1503070723.jpg"
    ))
    
}
