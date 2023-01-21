import Foundation

struct MealDetailResponse: Decodable {
  var meals: [MealDetail]
}

struct MealDetail: Decodable {
  var idMeal: String
  var strMeal: String
  var strCategory: String?
  var strTags: String?
  var strInstructions: String?
  var strMealThumb: String
}
