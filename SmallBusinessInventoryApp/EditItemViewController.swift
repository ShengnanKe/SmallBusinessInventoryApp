//
//  EditItemViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/11/24.
//

import UIKit
import CoreData

class EditItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var item: Item!
    var containers: [Container] = []
    var tags: [Tag] = []
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var containerPickerView: UIPickerView!
    @IBOutlet weak var tagPickerView: UIPickerView!
    @IBOutlet weak var ownershipSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Item"
        setupExistingData()
        configurePickerViews()
        configureImagePicker()
    }
    
    func setupExistingData() {
        nameTextField.text = item.name
        descriptionTextField.text = item.itemdescription
        ownershipSwitch.isOn = item.ownershipstatus
        
        if let imagePath = item.photo, !imagePath.isEmpty, let image = UIImage(contentsOfFile: imagePath) {
            imageView.image = image
        }
        
        loadPickerData()
    }
    
    func configurePickerViews() {
        containerPickerView.delegate = self
        containerPickerView.dataSource = self
        tagPickerView.delegate = self
        tagPickerView.dataSource = self
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func loadPickerData() {
        containers = DBManager.shared.fetchAllEntities(entityName: "Container") as? [Container] ?? []
        tags = DBManager.shared.fetchAllEntities(entityName: "Tag") as? [Tag] ?? []
        containerPickerView.reloadAllComponents()
        tagPickerView.reloadAllComponents()
        
        if let containerIndex = containers.firstIndex(where: { $0 == item.toContainer }) {
            containerPickerView.selectRow(containerIndex, inComponent: 0, animated: false)
        }
        if let tagIndex = tags.firstIndex(where: { $0 == item.hasTag }) {
            tagPickerView.selectRow(tagIndex + 1, inComponent: 0, animated: false) // +1 if you have a 'None' option
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == containerPickerView {
            return containers.count
        } else if pickerView == tagPickerView {
            return tags.count + 1  // +1 for 'None' option
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == containerPickerView {
            return containers[row].name
        } else if pickerView == tagPickerView {
            return (row == 0) ? "None" : tags[row - 1].name
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == containerPickerView {
            item.toContainer = containers[row]
        } else if pickerView == tagPickerView {
            item.hasTag = (row == 0) ? nil : tags[row - 1]
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else {
            showAlert(with: "Missing Information", message: "All fields must be filled.")
            return
        }
        
        item.name = name
        item.itemdescription = description
        item.ownershipstatus = ownershipSwitch.isOn
        
        if let context = item.managedObjectContext {
            do {
                try context.save()
                showAlert(with: "Success", message: "Item successfully updated.")
            } catch {
                print("Error saving context: \(error)")
                showAlert(with: "Error", message: "Failed to update the item.")
            }
        }
    }
    
    @IBAction func changeImageTapped(_ sender: Any) {
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageView.image = image
        
        // Save image
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let fileManager = FileManager.default
            let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = UUID().uuidString + ".jpg"
            let filePath = docDirectory.appendingPathComponent(fileName)
            
            do {
                try imageData.write(to: filePath)
                print("Saved image to: \(filePath)")
                item.photo = filePath.path
                if let context = item.managedObjectContext {
                    try context.save()  
                }
            } catch {
                print("Error saving image: \(error)")
                showAlert(with: "Error", message: "Failed to save image.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}



