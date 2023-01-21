//
//  MealViewController.swift
//  MealsApp
//
//  Created by Alfin on 20/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import APIRequest

class DetailViewController: UIViewController {
  let disposeBag = DisposeBag()
  private var mealDetailListVM: MealDetailListViewModel!
  var detailID = String()

  @IBOutlet weak var mealView: UIView!
  @IBOutlet weak var mealImage: UIImageView!
  @IBOutlet weak var mealName: UILabel!
  @IBOutlet weak var mealInstruction: UITextView!
  @IBOutlet weak var mealTags: UILabel!
  @IBOutlet weak var mealCategory: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupView()
  }

  private func populateDetail(completion: @escaping (MealDetailViewModel) -> Void) {
    let source = FetchSource<MealDetailResponse>(URL.urlForMealsDetail(id: detailID)!)
    URLRequest.load(resource: source)
      .subscribe(onNext: { meal in
        let meals = meal.meals
        self.mealDetailListVM = MealDetailListViewModel(meals)
        let mealsVM = self.mealDetailListVM.mealAt(0)
        completion(mealsVM)
      }).disposed(by: disposeBag)
  }
  private func setupUI() {
    self.populateDetail { [self] mealVM in
      mealVM.strInstructions.subscribe(onNext: { event in
        let Text = event.replacingOccurrences(of: "\r", with: "   ")
        DispatchQueue.main.async {
          self.mealInstruction.text = Text
        }
      }).disposed(by: disposeBag)
      mealVM.strMeal.subscribe(onNext: { event in
        DispatchQueue.main.async {
          self.mealName.text = event
        }
      }).disposed(by: disposeBag)
      mealVM.strTags.subscribe(onNext: { event in
        DispatchQueue.main.async {
          self.mealTags.text = event
        }
      }).disposed(by: disposeBag)
      mealVM.strCategory.subscribe(onNext: { event in
        DispatchQueue.main.async {
          self.mealCategory.text = event
        }
      }).disposed(by: disposeBag)
      mealVM.strMealThumb.subscribe(onNext: { event in
        DispatchQueue.main.async {
          KF.url(URL(string: event))
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .set(to: self.mealImage)
        }
      }).disposed(by: disposeBag)
    }
  }
  private func setupView() {
    self.mealView.layer.cornerRadius = 40
    self.mealView.layer.masksToBounds = true
    // making sure that corner radius is masked only for the top two corner not the remaning corners
    self.mealView.layer.maskedCorners = [.layerMaxXMinYCorner]
  }
}
