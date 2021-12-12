//
//  Fake.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 10.12.2021.
//

import Foundation


func createFakeData() -> Meals {
    let exampleJSON = """
    {
       "meals" : [
          {
             "dateModified" : null,
             "idMeal" : "53063",
             "strArea" : "Unknown",
             "strCategory" : "Beef",
             "strCreativeCommonsConfirmed" : null,
             "strDrinkAlternate" : null,
             "strImageSource" : null,
             "strIngredient1" : "Beef Brisket",
             "strIngredient10" : "Pepper",
             "strIngredient11" : "",
             "strIngredient12" : "",
             "strIngredient13" : "",
             "strIngredient14" : "",
             "strIngredient15" : "",
             "strIngredient16" : "",
             "strIngredient17" : "",
             "strIngredient18" : "",
             "strIngredient19" : "",
             "strIngredient2" : "Bread",
             "strIngredient20" : "",
             "strIngredient3" : "Lettuce",
             "strIngredient4" : "Tomato",
             "strIngredient5" : "Ham",
             "strIngredient6" : "Mozzarella",
             "strIngredient7" : "Bacon",
             "strIngredient8" : "Egg",
             "strIngredient9" : "Onion",
             "strInstructions" : "Crush the meat",
             "strMeal" : "Chivito uruguayo",
             "strMealThumb" : "https://www.themealdb.com/images/media/meals/n7qnkb1630444129.jpg",
             "strMeasure1" : "2",
             "strMeasure10" : "1",
             "strMeasure11" : " ",
             "strMeasure12" : " ",
             "strMeasure13" : " ",
             "strMeasure14" : " ",
             "strMeasure15" : " ",
             "strMeasure16" : " ",
             "strMeasure17" : " ",
             "strMeasure18" : " ",
             "strMeasure19" : " ",
             "strMeasure2" : "2",
             "strMeasure20" : " ",
             "strMeasure3" : "1",
             "strMeasure4" : "1",
             "strMeasure5" : "100g ",
             "strMeasure6" : "100g ",
             "strMeasure7" : "100g ",
             "strMeasure8" : "1",
             "strMeasure9" : "1",
             "strSource" : "https://cookpad.com/uy/recetas/116102-chivito-uruguayo",
             "strTags" : null,
             "strYoutube" : "https://www.youtube.com/watch?v=0PXbbL1QdaA&ab_channel=D%C3%ADadeCocina"
          },
          {
             "dateModified" : null,
             "idMeal" : "53061",
             "strArea" : "Croatian",
             "strCategory" : "Side",
             "strCreativeCommonsConfirmed" : null,
             "strDrinkAlternate" : null,
             "strImageSource" : null,
             "strIngredient1" : "Sardines",
             "strIngredient10" : "",
             "strIngredient11" : "",
             "strIngredient12" : "",
             "strIngredient13" : "",
             "strIngredient14" : "",
             "strIngredient15" : "",
             "strIngredient16" : "",
             "strIngredient17" : "",
             "strIngredient18" : "",
             "strIngredient19" : "",
             "strIngredient2" : "Vegetable Oil",
             "strIngredient20" : "",
             "strIngredient3" : "Flour",
             "strIngredient4" : "Salt",
             "strIngredient5" : "",
             "strIngredient6" : "",
             "strIngredient7" : "",
             "strIngredient8" : "",
             "strIngredient9" : "",
             "strInstructions" : "Wash the fish under the cold tap",
             "strMeal" : "Fresh sardines",
             "strMealThumb" : "https://www.themealdb.com/images/media/meals/nv5lf31628771380.jpg",
             "strMeasure1" : "500g",
             "strMeasure10" : " ",
             "strMeasure11" : " ",
             "strMeasure12" : " ",
             "strMeasure13" : " ",
             "strMeasure14" : " ",
             "strMeasure15" : " ",
             "strMeasure16" : " ",
             "strMeasure17" : " ",
             "strMeasure18" : " ",
             "strMeasure19" : " ",
             "strMeasure2" : "Dash",
             "strMeasure20" : " ",
             "strMeasure3" : "To Glaze",
             "strMeasure4" : "Dash",
             "strMeasure5" : " ",
             "strMeasure6" : " ",
             "strMeasure7" : " ",
             "strMeasure8" : " ",
             "strMeasure9" : " ",
             "strSource" : "https://www.visit-croatia.co.uk/croatian-cuisine/croatian-recipes/",
             "strTags" : "Fresh",
             "strYoutube" : "https://www.youtube.com/watch?v=DDaZoXP1Mdc"
          },
       ]
    }
    """.data(using: .utf8)!


    let fakeData = try! JSONDecoder().decode(Meals.self, from: exampleJSON)

    return fakeData
//    let trendsData = Trends(mealArray: fakeData)
//    return trendsData
}
