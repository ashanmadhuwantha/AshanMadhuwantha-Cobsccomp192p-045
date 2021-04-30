//
//  MenuViewController.swift
//  AshanMadhuwantha-Cobsccomp192p-045
//
//  Created by Ashan Madhuwantha on 2021-04-30.
//

import UIKit
import Firebase
import Loaf
import FirebaseDatabase
import FirebaseStorage

class MenuViewController: UIViewController {
    
    let databaseReference = Database.database().reference()
    
    var categoryList: [Category] = []

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtCategory: UITextField!
    
    var selectedImage: UIImage?
    var imagePicker: ImagePicker!
    var categoryPicker = UIPickerView()
    var selectedCategoryIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAdd.layer.cornerRadius = 20
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onPickImageClicked))
        self.imgFood.isUserInteractionEnabled = true
        self.imgFood.addGestureRecognizer(gesture)
        self.refreshCategories()
       
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAddFoodPressed(_ sender: UIButton) {
        
        let foodItem = FoodItem(
        foodName: txtName.text ?? "",
        foodId: "",
        foodDescription: txtDescription.text ?? "",
        foodPrice: Double(txtPrice.text ?? "") ?? 0,
        discount: Int(txtDiscount.text ?? "") ?? 0,
        foodImgRes: "",
        foodCategory: categoryList[selectedCategoryIndex].categoryName,
        availability: true)
        
        self.addFoodItem(foodItem: foodItem)
    }
    
    @objc func onPickImageClicked(_ sender: UIImageView) {
        self.imagePicker?.present(from: sender)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuViewController {
    
    func addFoodItem(foodItem: FoodItem) {
        
        guard let image = self.selectedImage else {
                    Loaf("Add an image", state: .error, sender: self).show()
                    return
                }
                
                if let uploadData = image.jpegData(compressionQuality: 0.5) {
                    
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpeg"
                    
                    Storage.storage().reference().child("foodItemImages").child(foodItem.foodName).putData(uploadData, metadata: metaData) {
                        meta, error in
                        
                        if let error = error {
                            print(error.localizedDescription)
                            Loaf(error.localizedDescription, state: .error, sender: self).show()
                            return
                        }
                        
                        Storage.storage().reference().child("foodItemImages").child(foodItem.foodName).downloadURL(completion: {
                            (url,error) in
                            guard let downloadURL = url else {
                                if let error = error {
                                    print(error.localizedDescription)
                                    Loaf(error.localizedDescription, state: .error, sender: self).show()
                                }
                                return
                            }
                            
        Loaf("Image uploaded", state: .success, sender: self).show()
        
        let data = [
            "food_name": foodItem.foodName,
            "description": foodItem.foodDescription,
            "price": foodItem.foodPrice,
            "discount": foodItem.discount,
            "category": foodItem.foodCategory,
            "isActive": foodItem.availability,
            "image": downloadURL.absoluteString
        
        ] as [String : Any]
        
                            self.databaseReference
                                                   .child("foodItems")
                                                   .childByAutoId()
                                                   .setValue(data) {
                                                       error, ref in
                                                       if let error = error {
                                                           Loaf(error.localizedDescription, state: .error, sender: self).show()
                                                       } else {
                                                           Loaf("Food item added", state: .success, sender: self).show()
                                                       }
                                                   }
                                               
                                           })
                                       }
                                   }
                                   
                               }
    
    func refreshCategories() {
        self.categoryList.removeAll()
        databaseReference.child("categories").observeSingleEvent(of: .value, with: {
            snapshot in
            if snapshot.hasChildren() {
                guard let data = snapshot.value as? [String: Any] else {
                    return
                }
                for category in data {
                    if let categoryInfo = category.value as? [String: String] {
                        self.categoryList.append(Category(categoryName: categoryInfo["name"]!, categoryID:category.key))
                    }
                }
                self.setupCategoryPicker()
            }
        })
    }
}

extension MenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
        func setupCategoryPicker() {
            
            let pickerToolBar = UIToolbar()
            pickerToolBar.sizeToFit()
            
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onPickerCancelled))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            pickerToolBar.setItems([space, cancelButton], animated: true)
            
            txtCategory.inputAccessoryView = pickerToolBar
            txtCategory.inputView = categoryPicker
            categoryPicker.delegate = self
            categoryPicker.dataSource = self
        }
        
        @objc func onPickerCancelled() {
            self.view.endEditing(true)
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return categoryList.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return categoryList[row].categoryName
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            txtCategory.text = categoryList[row].categoryName
            selectedCategoryIndex = row
        }
    }


extension MenuViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imgFood.image = image
        self.selectedImage = image
    }
}
