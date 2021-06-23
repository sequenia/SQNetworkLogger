import UIKit

extension UITableView {
    
    func sq_register<T: UITableViewCell>(_ cellClass: T.Type, identifier: String? = nil) {
        self.register(T.self.sq_nib,
                      forCellReuseIdentifier: identifier != nil ? identifier! : T.self.sq_identifier)
    }
    
    func sq_dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, indexPath: IndexPath, identifier: String? = nil) -> T? {
        return self.dequeueReusableCell(withIdentifier: identifier != nil ? identifier! : T.self.sq_identifier,
                                        for: indexPath) as? T
    }
    
}


extension UIView {
    
    class var sq_identifier: String {
        return String.init(describing: self)
    }
    
    class var sq_nib: UINib {
        return UINib.init(nibName: self.sq_identifier, bundle: Bundle.module)
    }
}
