//
//  ReusableProtocolswift.swift
//  WeatherDiary
//
//  Created by Seokjune Hong on 2022/08/13.
//

import Foundation
import UIKit

protocol ReusableProtocl {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableProtocl {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocl {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
