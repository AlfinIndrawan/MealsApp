//
//  ViewController.swift
//  MealsApp
//
//  Created by Alfin on 20/01/23.
//

import UIKit
import APIRequest
import RxSwift
import RxCocoa
import Kingfisher

class ViewController: UIViewController {
  let disposeBag = DisposeBag()
  private var mealListVM: MealListViewModel!

  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var mealsTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    populateMeals()
    setupMeals()
    searchValue()
  }
  private func populateMeals() {
    let source = FetchSource<MealResponse>(URL.urlForMeals()!)
    URLRequest.load(resource: source)
      .subscribe(onNext: { meal in
        let meals = meal.meals
        self.mealListVM = MealListViewModel(meals)
        DispatchQueue.main.async {
          self.mealsTableView.reloadData()
        }
      }).disposed(by: disposeBag)
  }
  private func fetchMeal(_ name: String) {
    let source = FetchSource<MealResponse>(URL.urlForSearch(name: name)!)
    URLRequest.load(resource: source)
      .subscribe(onNext: { meal in
        let meals = meal.meals
        self.mealListVM = MealListViewModel(meals)
        DispatchQueue.main.async {
          self.mealsTableView.reloadData()
        }
      }).disposed(by: disposeBag)
  }

  private func setupMeals() {
    mealsTableView.dataSource = self
    mealsTableView.delegate = self
    mealsTableView.layer.masksToBounds = true
  }

  private func searchValue() {
    self.searchTextField.rx.controlEvent(.editingDidEndOnExit)
      .asObservable()
      .map {
        self.searchTextField.text
      }
      .subscribe(onNext: { name in
        if let name = name {
          print(name)
          if name.isEmpty {
            self.populateMeals()
          } else {
            self.fetchMeal(name)
          }
        }
      }).disposed(by: disposeBag)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailsVC = segue.destination as? DetailViewController, let id = sender as? String {
      detailsVC.detailID = id
    }
  }
}

// MARK: UITableVIew

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.mealListVM == nil ? 0: self.mealListVM.mealVM.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as? MealTableViewCell else {
      fatalError("meal cell identifier not found")
    }

    let mealVM = self.mealListVM.mealAt(indexPath.row)

    // im using driver because i dont need dispatch queue to update with driver
    mealVM.strMeal.asDriver(onErrorJustReturn: "")
      .drive(cell.mealName.rx.text)
      .disposed(by: disposeBag)

    mealVM.strMealThumb
      .subscribe(onNext: { url in
        KF.url(URL(string: url))
          .cacheMemoryOnly()
          .fade(duration: 0.25)
          .onProgress {_, _ in
            cell.indicatorView.startAnimating()
          }
          .retry(DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(10)))
          .onSuccess { _ in
            cell.indicatorView.stopAnimating()
            cell.indicatorView.isHidden = true
          }
          .set(to: cell.mealImageView)
      }).disposed(by: disposeBag)
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let mealDetail = mealListVM.didSelect(at: indexPath.row)
    var id = String()
    mealDetail.idMeal.subscribe(onNext: {
      id = $0
    }).disposed(by: disposeBag)
    performSegue(withIdentifier: "mealDetail", sender: id)
  }
}
