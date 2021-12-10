//
//  MealsDataProviderStub.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 10.12.2021.
//

import Foundation

final class MealsDataProviderStub: MealsDataProvider {
    func fetchRandomMeals(completionHandler: @escaping MealsFetchCompletion) {
        do {
            let meals = try JSONDecoder().decode(Meals.self, from: stubDataMeal)
            completionHandler(.success(meals))
        } catch {
            completionHandler(.failure(.unparsableData))
        }
    }

    func fetchRandomPreviewMeals(completionHandler: @escaping MealsFetchCompletion) {
        do {
            let meals = try JSONDecoder().decode(Meals.self, from: stubDataMealPreview)
            completionHandler(.success(meals))
        } catch {
            completionHandler(.failure(.unparsableData))
        }
    }
}

fileprivate let stubDataMeal = """
    {
       "meals" : [
          {
             "dateModified" : null,
             "idMeal" : "52927",
             "strArea" : "Canadian",
             "strCategory" : "Beef",
             "strCreativeCommonsConfirmed" : null,
             "strDrinkAlternate" : null,
             "strImageSource" : null,
             "strIngredient1" : "Beef Brisket",
             "strIngredient10" : "Paprika",
             "strIngredient11" : "Garlic",
             "strIngredient12" : "Onion",
             "strIngredient13" : "Dill",
             "strIngredient14" : "English Mustard",
             "strIngredient15" : "Celery Salt",
             "strIngredient16" : "Red Pepper Flakes",
             "strIngredient17" : "",
             "strIngredient18" : "",
             "strIngredient19" : "",
             "strIngredient2" : "Salt",
             "strIngredient20" : "",
             "strIngredient3" : "Black Pepper",
             "strIngredient4" : "Coriander",
             "strIngredient5" : "Sugar",
             "strIngredient6" : "Bay Leaf",
             "strIngredient7" : "Cloves",
             "strIngredient8" : "Black Pepper",
             "strIngredient9" : "Coriander",
             "strInstructions" : "To make the cure...",
             "strMeal" : "Montreal Smoked Meat",
             "strMealThumb" : "https://www.themealdb.com/images/media/meals/uttupv1511815050.jpg",
             "strMeasure1" : "1",
             "strMeasure10" : "1 tbs",
             "strMeasure11" : "1 tbs",
             "strMeasure12" : "1 tbs",
             "strMeasure13" : "1 tbs",
             "strMeasure14" : "1 tsp ",
             "strMeasure15" : "1 tbs",
             "strMeasure16" : "1 tsp ",
             "strMeasure17" : "",
             "strMeasure18" : "",
             "strMeasure19" : "",
             "strMeasure2" : "3 tbs",
             "strMeasure20" : "",
             "strMeasure3" : "3 tbs",
             "strMeasure4" : "1 tbs",
             "strMeasure5" : "1 tbs",
             "strMeasure6" : "1 tsp ",
             "strMeasure7" : "1 tsp ",
             "strMeasure8" : "3 tbs",
             "strMeasure9" : "1 tbs",
             "strSource" : "http://www.meatwave.com/blog/montreal-smoked-meat-recipe",
             "strTags" : "Speciality,Snack,StrongFlavor",
             "strYoutube" : "https://www.youtube.com/watch?v=g5oCDoyxbBk"
          }
       ]
    }
""".data(using: .utf8)!

fileprivate let stubDataMealPreview = """
    {
      "meals": [
          {
             "strMeal": "Baked salmon with fennel &amp; tomatoes",
             "strMealThumb": "https://www.themealdb.com/images/media/meals/1548772327.jpg",
             "idMeal": "52959"
          },
          {
             "strMeal": "Cajun spiced fish tacos",
             "strMealThumb": "https://www.themealdb.com/images/media/meals/uvuyxu1503067369.jpg",
             "idMeal": "52819"
          },
          {
             "strMeal": "Escovitch Fish",
             "strMealThumb": "https://www.themealdb.com/images/media/meals/1520084413.jpg",
             "idMeal": "52944"
          }
      ]
    }

""".data(using: .utf8)!
