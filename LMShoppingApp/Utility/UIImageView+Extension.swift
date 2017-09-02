//
//  UIImageView+Extension.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 01/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    /**
     Download Image from async in background
     - parameter url: Image's url from which need to download
     - parameter contentMode: ImageView's content mode, defalut to 'scaleAspectFit'
    */
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, comletionHandler: (() -> Void)? = nil) {
        contentMode = mode
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    comletionHandler?()
                    return
            }
            
            //Update view's image in main thread
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                
                comletionHandler?()
            }
            }.resume()
    }
    
    /**
     Download Image from async in background
     - parameter link: Image's urlString from which need to download
     - parameter contentMode: ImageView's content mode, defalut to 'scaleAspectFit'
     */
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, comletionHandler: (() -> Void)? = nil) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode, comletionHandler: comletionHandler)
    }
}
