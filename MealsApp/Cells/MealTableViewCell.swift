//
//  MealTableViewCell.swift
//  MealsApp
//
//  Created by Alfin on 20/01/23.
//

import UIKit

class MealTableViewCell: UITableViewCell {

  @IBOutlet weak var mealImageView: CustomImageView!
  @IBOutlet weak var mealName: UILabel!
  @IBOutlet weak var indicatorView: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.indicatorView.startAnimating()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }

}
