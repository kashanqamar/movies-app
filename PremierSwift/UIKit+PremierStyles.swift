import UIKit

extension UIColor {
    
    static var titleText: UIColor {
        return darkGray
    }
    
    static var bodyText: UIColor {
        return gray
    }
}

extension UIFont {
    
    static var title: UIFont {
        return preferredFont(forTextStyle: .title1)
    }
    
    static var subtitle: UIFont {
        return preferredFont(forTextStyle: .subheadline)
    }
    
    static var body: UIFont {
        return preferredFont(forTextStyle: .body)
    }
   
}
