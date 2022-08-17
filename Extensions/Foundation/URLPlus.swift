//
//  URLPlus.swift
//  zeniko
//
//  Created by Choi on 2022/8/17.
//

import Foundation

extension URL {
    static let documentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = urls.first else {
            fatalError("NOT OK")
        }
        return url
    }()
}
