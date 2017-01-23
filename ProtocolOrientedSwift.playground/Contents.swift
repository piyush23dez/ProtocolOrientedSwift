

import UIKit

protocol NibLoadableView: class { }
protocol ReusableView: class { }


//provide default implementation for above protocols
extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
       return String(describing: self)
    }
}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//let UITableViewCell conforms to above protocols, so all the UITableView subclasses will have above methods
extension UITableViewCell: NibLoadableView { }
extension UITableViewCell: ReusableView { }


//let all UITableViews in your project have 2 methods for registering and dequeuing cells
extension UITableView {
    
    //register a custom cell class which conforms to above protocols
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    //dequeue that cell for resuing in tableView with reuse identifier
    func dequeueReuseableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath)
        as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")

        }
        return cell
    }
}

//tableView.register(CustomTableViewCell.self)
//let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CustomTableViewCell