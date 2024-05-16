//
//  AddItemDetailViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/15/24.
//

import UIKit
import CoreData

class AddItemDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate, AddTagViewControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var containerPickerView: UIPickerView!
    @IBOutlet weak var ownershipSwitch: UISwitch!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var saveItemButton: UIButton!
    @IBOutlet weak var addTagButton: UIButton!
    
    var item: Item?
    var containers: [Container] = []
    var selectedContainer: Container?
    var selectedTag: Tag?
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerPickerView.delegate = self
        containerPickerView.dataSource = self
        
        if let item = item {
            nameTextField.text = item.name
            descriptionTextField.text = item.itemdescription
            ownershipSwitch.isOn = item.ownershipstatus
        } else {
            nameTextField.placeholder = "Enter item name here: "
            descriptionTextField.placeholder = "Enter a description here: "
        }
        
        setupImagePicker()
        loadPickerData()
    }
    
    func loadPickerData() {
        containers = DBManager.shared.fetchAllEntities(entityName: "Container") as? [Container] ?? []
        
        if containers.isEmpty {
            print("No containers available")
        }

        DispatchQueue.main.async {
            self.containerPickerView.reloadAllComponents()
        }
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    @IBAction func addTagButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addTagVC = storyboard.instantiateViewController(withIdentifier: "AddTagViewController") as? AddTagViewController {
            addTagVC.delegate = self
            navigationController?.pushViewController(addTagVC, animated: true)
        }
    }
    
    func didSelectTag(_ tag: Tag) {
        selectedTag = tag
        print("Selected Tag: \(selectedTag?.name ?? "No Name")")
    }
    
    @IBAction func saveItemButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty,
              let selectedContainer = selectedContainer else {
            showAlert(with: "Missing Information", message: "Please fill in everything")
            return
        }
        
        let ownershipStatus = ownershipSwitch.isOn
        
        let imagePath: String
        if let image = itemImageView.image {
            imagePath = saveImageAndGetPath(image: image)
        } else {
            imagePath = "default/path"
        }
        
        let itemModel = ItemModel(name: name, itemDescription: description, ownershipStatus: ownershipStatus, photo: imagePath)
        
        let success = DBManager.shared.addItem(with: itemModel, container: selectedContainer, tag: selectedTag)
        
        if success {
            showAlert(with: "Success", message: "Item was successfully saved.")
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(with: "Error", message: "Failed to save the item.")
        }
    }
    
    private func saveImageAndGetPath(image: UIImage) -> String {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return "default/path"
        }
        
        let fileManager = FileManager.default
        let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let uniqueIdentifier = ProcessInfo.processInfo.globallyUniqueString
        let fileName = "\(timestamp)-\(uniqueIdentifier).jpg"
        
        let filePath = docDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: filePath)
            print("Saved image to: \(filePath)")
            return filePath.path
        } catch {
            print("Error!! cannot save image: \(error)")
            return "default/path"
        }
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return containers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return containers[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedContainer = containers[row]
        print("Selected Container: \(selectedContainer?.name ?? "No Name")")
    }

    
    @IBAction func takePhotoFromCamera(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true)
        } else {
            print("Camera not available")
        }
    }
    
    @IBAction func takePhotoFromGallery(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        itemImageView.image = image
        
        let imagePath = saveImageAndGetPath(image: image)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
