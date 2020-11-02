
import UIKit

@IBDesignable
// to create round buttons
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
        self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    /*
     Instead of creating a new class I jkinda of just hijacked the
     RoundButton class, it would be easy enough to create a new
     one that would ever be an issue but for proof of concept purposes
     this should be fine
     */
    
    // creates an instance of the gradient class
    let gradientLayer = CAGradientLayer()
    
    // stores the color data for the gradient of the top color
    // you can select any color through the storyboard
    // once you select the class for the button
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    // ditto for the bottom
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }

    /*
     sets the gradient for the button
     
     the gradient layer works with CGPoints where the top left corner
     of the button is considere 0,0 and the bottom right is considered 1.0
     
     therefore by setting the top as 0.0, 0.0 and the bottom 1.0, 1.0
     we can effectively create a gradient from top to bottom
     
     this can easily be changed to 0.0, 0.5 and 0.5, 1.0
     to create a change vertically
     */
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            
            // sets the gradient to fill the full bounds of the view
            gradientLayer.frame = bounds
            // sets teh colors
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            // seems to be unnecesary as I'm not updating the button...yet
            // gradientLayer.removeFromSuperLayer()
        }
    }
}
