//
//  CategoryViewController.swift
//  AshanMadhuwantha-Cobsccomp192p-045
//
//  Created by Ashan Madhuwantha on 2021-04-30.
//

import UIKit
import  FirebaseDatabase
import Loaf

class CategoryViewController: UIViewController {

    let databaseReference = Database.database().reference()
    
    var categoryList: [Category] = []
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAdd.layer.cornerRadius = 20
        tblCategory.register(UINib(nibName: CategoryTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        refreshCategories()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onAddCategoryPressed(_ sender: UIButton) {
        
        if let name = txtName.text {
            addCategory(name: name)
        } else {
            Loaf("Enter a Category Name", state: .error, sender: self).show()
        }
       
    }
}
    
extension CategoryViewController {
    
    func addCategory(name: String) {
        databaseReference.child("categories").childByAutoId().child("name").setValue(name) {
            error, ref in
            if let error = error {
                Loaf(error.localizedDescription, state: .error, sender: self).show()
            } else {
                Loaf("Category Added", state: .success, sender: self).show()
                self.refreshCategories()
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
                        self.categoryList.append(Category(categoryName: categoryInfo["name"]!, categoryId:category.key))
                    }
                }
                self.tblCategory.reloadData()
            }
        })
    }
    
    func removeCategory(category: Category) {
        databaseReference.child("categories").child(category.categoryId).removeValue() {
            error, databaseReference in
            if error != nil {
                Loaf("Could Not Remove Category", state: .error, sender: self).show()
            } else {
                Loaf("Category Removed", state: .success, sender: self).show()
                self.refreshCategories()
            }
        }
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategory.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as! CategoryTableViewCell
        cell.selectionStyle = .none
        cell.configXIB(category: self.categoryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeCategory(category: categoryList[indexPath.row])
            refreshCategories()
            
        }
    }
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


