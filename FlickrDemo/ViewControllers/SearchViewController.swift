//
//  SearchViewController.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var perPageField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        
        // Do any additional setup after loading the view.
    }
    
    private func configView() {
        self.searchButton.setBackgroundImage(AIUtility.getImageWithColor(color: UIColor.flickrButtonGrayColor()), for: .normal)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "search", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            let vc = segue.destination as! SearchResultsCollectionViewController
            vc.searchText = self.searchTextField.text
            vc.limit = Int(self.perPageField.text ?? "0")
        }
    }
}

// Mark: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if verifyInput() {
            self.searchButton.setBackgroundImage(AIUtility.getImageWithColor(color: UIColor.flickrButtonBlueColor()), for: .normal)
            self.searchButton.isUserInteractionEnabled = true
        } else {
            self.searchButton.setBackgroundImage(AIUtility.getImageWithColor(color: UIColor.flickrButtonGrayColor()), for: .normal)
            self.searchButton.isUserInteractionEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchTextField {
            self.perPageField.becomeFirstResponder()
        }
        return true
    }
    
    func verifyInput() -> Bool {
        if self.searchTextField.text?.count ?? 0 > 0 && self.perPageField.text?.count ?? 0 > 0 && self.perPageField.text != "0" {
            return true
        } else {
            return false
        }
    }
}
