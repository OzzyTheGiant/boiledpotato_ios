import UIKit
import Stevia

extension UIColor {
    class var neutral: UIColor { fetchColor(name: "COL_Neutral", hex: 0x000000) }
    class var primary: UIColor { fetchColor(name: "COL_Primary", hex: 0xFFE55F)}
    class var primary_dark: UIColor { fetchColor(name: "COL_Primary_Dark", hex: 0xEEC500) }
    class var accent: UIColor { fetchColor(name: "COL_Accent", hex: 0xB35321) }
    
    private class func fetchColor(name: String, hex: Int) -> UIColor {
        if #available(iOS 11, *) {
            return UIColor(named: name)!
        } else {
            return UIColor(hex: hex)
        }
    }

    convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
    }
}

extension UIButton {
    convenience init(textKey: String, iconKey: String) {
        self.init()
        self.setTitle(NSLocalizedString(textKey, comment: ""), for: .normal)
        self.setImage(UIImage(named: iconKey), for: .normal)
    }
    
    func alignImageAndTitleVertically(
        padding: CGFloat = Dimens.padding_button_cuisine,
        iconSize: CGFloat = Dimens.icon_size_cuisine,
        totalSize: CGFloat = Dimens.button_size_cuisine
    ) {
        let titleSize = self.titleLabel!.frame.size
        
        // apparently, constraints do not work on UIButton titleLabels, so edge insets are needed
        self.titleEdgeInsets = UIEdgeInsets(
            top: iconSize + padding,
            left: -(totalSize - titleSize.width) / 3,
            bottom: 0,
            right: 0
        )
        
        self.imageView!.translatesAutoresizingMaskIntoConstraints = false
        self.imageView!.CenterX == self.CenterX
        self.imageView!.Top == self.Top + padding
        self.imageView!.size(iconSize)
    }
}
