//
//  AddItemViewController.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/8/24.
//

/*
 
 Location to Section: One-to-Many
 Each Location -> multiple Sections, each Section -> one Location.
 delete rule -> cascade -> when you delete a location, the sections under this location will be deleted too.
 
 Section to Container: One-to-Many
 Each Section -> multiple Containers, each Container -> one Section.
 delete rule -> cascade -> when you delete a section, the containers under this section will be deleted too.
 
 Container to Item: One-to-Many
 Each Container -> multiple Items, each Item -> one Container.
 delete rule -> cascade -> when you delete a container, the items under this container will be deleted too.
 
 Item to Tag: One-to-One
 
 
 Location: id & name
 Section: id & name
 Container: id & name
 Item: id, name, photo(save the path to the file -> String), description, ownership status, tag(s)
 
 */

// add logic in the view, not in table view cell
// cellForRowAt -> cell.imageview
// reloadCell
// tableview.reloadData

import UIKit
import CoreData

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var item: Item?
    var containers: [Container] = []
    var tags: [Tag] = []
    var selectedContainer: Container?
    var selectedTag: Tag?
    
    @IBOutlet weak var AddItemViewControllerLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var containerPickerView: UIPickerView!
    @IBOutlet weak var ownershipSwitch: UISwitch!
    @IBOutlet weak var tagPickerView: UIPickerView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddItemViewControllerLabel.text = "Add Item"
        
        // setupPickerViews()
        containerPickerView.delegate = self
        containerPickerView.dataSource = self
        tagPickerView.delegate = self
        tagPickerView.dataSource = self
        
        if let item = item {
            nameTextField.text = item.name
            descriptionTextField.text = item.itemdescription
        } else {
            nameTextField.placeholder = "Enter item name here: "
            descriptionTextField.placeholder = "Enter a description here: "
        }
        
        // borrowed / owned
        ownershipSwitch.isOn = item?.ownershipstatus ?? false // -> default to borrowed, true owned
        ownershipSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        cameraButton.setTitle("Camera", for: .normal)
        galleryButton.setTitle("Gallery", for: .normal)
        addItemButton.setTitle("Save Item", for: .normal)
        
        loadPickerData()
        
        // pre-load some data
        //DBManager.shared.preloadLocationsSectionsContainersTags()
        
        let url = NSPersistentContainer.defaultDirectoryURL()
        print("url: ", url)
        
        setupImagePicker()
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        print("Switch new value: \(sender.isOn)")
    }
    
    func loadPickerData() {
        containers = DBManager.shared.fetchAllEntities(entityName: "Container") as? [Container] ?? []
        tags = DBManager.shared.fetchAllEntities(entityName: "Tag") as? [Tag] ?? []
        
        // Print to check how many containers and tags were loaded
        //print("Loaded \(containers.count) containers and \(tags.count) tags")
        
        if containers.isEmpty || tags.isEmpty {
            print("No containers or tags available")
        }

        DispatchQueue.main.async {
            self.containerPickerView.reloadAllComponents()
            self.tagPickerView.reloadAllComponents()
        }
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == containerPickerView {
            return containers.count
        } else if pickerView == tagPickerView {
            return tags.count + 1 // add "none" -> an item may not have tag
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == containerPickerView {
            return containers[row].name
        } else if pickerView == tagPickerView {
            if row == 0 {
                return "None"  // no tag
            } else {
                return tags[row - 1].name
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == tagPickerView {
            selectedTag = (row == 0) ? nil : tags[row - 1]
        } else if pickerView == containerPickerView {
            selectedContainer = containers[row] //.name
            print("Selected Container: \(selectedContainer?.name ?? "No Name") with ID: \(selectedContainer?.objectID)")
        }
    }
    
    @IBAction func selectImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty,
              let selectedContainer = selectedContainer else {
            showAlert(with: "Missing Information", message: "Please fill in all fields.")
            return
        }
        
        let ownershipStatus = ownershipSwitch.isOn
        
        let imagePath: String
        if let image = itemImageView.image {
            imagePath = saveImageAndGetPath(image: image)
        } else {
            imagePath = "default/path"
        }
        
        let itemModel = ItemModel(id: UUID(), name: name, itemDescription: description, ownershipStatus: ownershipStatus, photo: imagePath)
        
        let success = DBManager.shared.addItem(with: itemModel, container: selectedContainer, tag: selectedTag)
        
        if success {
            showAlert(with: "Success", message: "Item was successfully saved.")
            resetForm()
        } else {
            showAlert(with: "Error", message: "Failed to save the item.")
        }
    }
    
    private func resetForm() {
        nameTextField.text = ""
        descriptionTextField.text = ""
        itemImageView.image = nil
        ownershipSwitch.setOn(false, animated: true)
        selectedContainer = nil
        selectedTag = nil
    }
    
    func saveImageAndGetPath(image: UIImage) -> String {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                return "default/path"  //  default path
            }
        
        let fileManager = FileManager.default
        let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".jpg"
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
    
    
}


extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    //        if let pickedImage = info[.editedImage] as? UIImage {
    //            itemImageView.image = pickedImage
    //        }
    //        picker.dismiss(animated: true)
    //    }
    
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

