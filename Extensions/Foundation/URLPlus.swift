//
//  URLPlus.swift
//  zeniko
//
//  Created by Choi on 2022/8/17.
//

import Foundation

extension URL {
    
    static func ubiquityContainer(identifier: String?) -> URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: identifier)
    }
    
    static var libraryDirectory: URL {
        guard let url = url(for: .libraryDirectory) else {
            fatalError("NOT OK")
        }
        return url
    }
    
    static var documentDirectory: URL {
        guard let url = url(for: .documentDirectory) else {
            fatalError("NOT OK")
        }
        return url
    }
    
    static func url(for path: FileManager.SearchPathDirectory) -> URL? {
        FileManager.default.urls(for: path, in: .userDomainMask).first
    }
}

extension URL: OptionalType {
    var optionalValue: URL? {
        self
    }
}
