//
//  ViewController+FlickrHelper.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(_ error: Error) {
        let alertController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
        
        alertController.addAction(accept)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showErrorAlert(_ title: String?, message: String?) {
        let alertController = UIAlertController(title: title!, message: message!, preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
        
        alertController.addAction(accept)
        
        self.present(alertController, animated: true, completion:nil)
    }
}
