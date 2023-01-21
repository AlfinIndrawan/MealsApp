import RxCocoa
import RxSwift

// root view model. to give flexible room because and meal list view model will display all article on screen. and if have segmented control and other can use this model
struct MealListViewModel {
  let mealVM: [MealViewModel]
    // override so that we can initalize by passing articles
  init(_ meals: [Meal]) {
    self.mealVM = meals.compactMap(MealViewModel.init)
  }
}
// to give to tableview
extension MealListViewModel {
  func mealAt(_ index: Int) -> MealViewModel {
    return self.mealVM[index]
  }
  func didSelect(at indexPath: Int) -> MealViewModel {
    return self.mealVM[indexPath]
     }
}

// represent each single meal its going to have acces meal model and create init
// to assign article to property we have

struct MealViewModel {
  let meal: Meal

  init(_ meal: Meal) {
    self.meal = meal
  }
}

extension MealViewModel {
  var strMeal: Observable<String> {
    return Observable<String>.just(meal.strMeal)
  }
  var strMealThumb: Observable<String> {
    return Observable<String>.just(meal.strMealThumb)
  }
  var idMeal: Observable<String> {
    return Observable<String>.just(meal.idMeal)
  }

}
