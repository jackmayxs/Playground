//
//  Storyboarded.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import UIKit

protocol Storyboarded {
    static var bundle: Bundle { get }
    static var storyboardName: String { get }
    static var instantiate: Self { get }
}

extension Storyboarded where Self: UIViewController {
    static var bundle: Bundle { .main }
    static var storyboardName: String { "Main" }
    static var instantiate: Self {
        let storyboardId = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let instance = storyboard.instantiateViewController(withIdentifier: storyboardId) as? Self else {
            fatalError("Fail to instantiate view controller with identifier \(storyboardId). Check again.")
        }
        return instance
    }
}
