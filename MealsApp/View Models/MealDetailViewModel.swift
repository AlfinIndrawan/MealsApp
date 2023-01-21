import RxSwift
import RxCocoa

struct MealDetailListViewModel {
  let mealDetail: [MealDetailViewModel]
    // override so that we can initalize by passing articles
  init(_ meals: [MealDetail]) {
    self.mealDetail = meals.compactMap(MealDetailViewModel.init)
  }
}
// to give to tableview
extension MealDetailListViewModel {
  func mealAt(_ index: Int) -> MealDetailViewModel {
    return self.mealDetail[index]
  }
}

// represent each single meal its going to have acces meal model and create init
// to assign article to property we have

struct MealDetailViewModel {
  let mealDetail: MealDetail

  init(_ meal: MealDetail) {
    self.mealDetail = meal
  }
}

extension MealDetailViewModel {
  var strMeal: Observable<String> {
    return Observable<String>.just(mealDetail.strMeal)
  }
  var strMealThumb: Observable<String> {
    return Observable<String>.just(mealDetail.strMealThumb)
  }
  var idMeal: Observable<String> {
    return Observable<String>.just(mealDetail.idMeal)
  }
  var strCategory: Observable<String> {
    return Observable<String>.just(mealDetail.strCategory ?? "")
  }
  var strInstructions: Observable<String> {
    return Observable<String>.just(mealDetail.strInstructions ?? "")
  }
  var strTags: Observable<String> {
    return Observable<String>.just(mealDetail.strTags ?? "")
  }

}
