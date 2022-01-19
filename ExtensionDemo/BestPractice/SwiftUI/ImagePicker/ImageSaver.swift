//
//  ImageSaver.swift
//  SwiftUIDemo
//
//  Created by Choi on 2021/12/30.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
