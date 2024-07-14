# Meal Browser

**Meal Browser** is a native iOS app that allows users to browse recipes from the MealDB API. It focuses on fetching and displaying recipes from the Dessert category.

## Features

- Fetches a list of meals in the Dessert category from the MealDB API.
- Displays the list of meals sorted alphabetically.
- Allows users to select a meal to view its details.
- Shows meal details including:
  - Meal name
  - Instructions
  - Ingredients with measurements
- Utilizes Swift Concurrency (async/await) for all asynchronous operations.
- Filters out null or empty values from the API responses.
- Provides a user-friendly interface optimized for iOS devices.

## Implementation Details

- **Swift Concurrency**: All asynchronous operations are implemented using async/await to ensure responsiveness and clarity in code.
- **API Endpoints**:
  - `https://themealdb.com/api/json/v1/1/filter.php?c=Dessert`: Used to fetch the list of meals in the Dessert category.
  - `https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID`: Used to fetch detailed information about a specific meal by its ID.
- **UI/UX Design**: While UI/UX design is not the primary focus, basic app design principles are followed to ensure usability.
- **Xcode Compatibility**: The project is designed to compile using the latest version of Xcode.

## Getting Started

To run the app on your local machine:

1. Clone this repository: `git clone https://github.com/your/repository.git`
2. Open the project in Xcode.
3. Build and run the project on a simulator or device.

## Video Walkthrough


![Simulator Screen Recording - iPhone 15 Pro - 2024-07-13 at 21 23 29](https://github.com/user-attachments/assets/302315ca-bd10-4792-a7e9-b83ffd8e745a)



## License

    Copyright [2024] [@FredyCamas]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
