// @IBDesignable is any variable that have ib inspectable in front of it appear inside of attribute inspector in interface builder
import UIKit

@IBDesignable
class CustomView: UIView {
  @IBInspectable var cornerRadius: CGFloat = 0.0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.cornerCurve = .continuous
    }
  }

  @IBInspectable var shadowOpacity: Float = 0.0 {
    didSet {
      layer.shadowOpacity = shadowOpacity
    }
  }

  @IBInspectable var shadowOffset: Int = 0 {
    didSet {
      layer.shadowOffset = CGSize(width: 0, height: shadowOffset)
    }
  }

  @IBInspectable var borderWidth: CGFloat = 0.0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }

  @IBInspectable var borderColor: UIColor = UIColor.clear {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }
}
