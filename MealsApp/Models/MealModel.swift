import Foundation

struct MealResponse: Decodable {
  var meals: [Meal]
}

struct Meal: Decodable {
  var strMeal: String
  var strMealThumb: String
  var idMeal: String
}
