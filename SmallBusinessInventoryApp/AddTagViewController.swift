//
//  AddTagViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/15/24.
//

// AddTagViewController.swift

import UIKit

protocol AddTagViewControllerDelegate: AnyObject {
    func didSelectTag(_ tag: Tag)
}

class AddTagViewController: UIViewController {
    
    @IBOutlet weak var tagNameTextField: UITextField!
    @IBOutlet weak var saveTagButton: UIButton!
    
    weak var delegate: AddTagViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagNameTextField.placeholder = "Please enter tag name here:"
        saveTagButton.setTitle("Save Tag", for: .normal)
    }
    
    @IBAction func saveTagButtonTapped(_ sender: UIButton) {
        guard let tagName = tagNameTextField.text, !tagName.isEmpty else {
            showAlert(with: "Missing Information", message: "Please enter a tag name.")
            return
        }
        
        if let tag = DBManager.shared.addTag(with: tagName) {
            delegate?.didSelectTag(tag)
            showAlert(with: "Success", message: "Tag was successfully saved.")
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(with: "Error", message: "Failed to save the tag.")
        }
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
