//
//  AppConstant.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//

import UIKit

class AppConstant {
    static let KKBOXAPIClientID = "badfec606bd902d5fb9a3208c10bf8e9"
    static let KKBOXAPISecret = "d1aff23b93e44241171944ac2db1fa3d"
}

extension UIColor {
    static var kkbox: UIColor {
        return UIColor(red: 75/255, green: 167/255, blue: 205/255, alpha: 1)
    }
}

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
extension UICollectionReusableView: Reusable {}

extension UITableView {
    func register(cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func register(headerClass: UITableViewHeaderFooterView.Type) {
        register(headerClass, forHeaderFooterViewReuseIdentifier: headerClass.reuseIdentifier)
    }
}

extension UICollectionView {
    func register(cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}

extension UIImageView {
    func setImage(with url: URL, callBack: @escaping () -> Void = {}) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
                callBack()
            }
        }
    }
}
