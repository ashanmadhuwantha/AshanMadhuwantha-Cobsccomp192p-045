//
//  FoodTableViewCell.swift
//  AshanMadhuwantha-Cobsccomp192p-045
//
//  Created by Ashan Madhuwantha on 2021-04-28.
//

import UIKit
import Kingfisher

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFoodDiscount: UILabel!
    @IBOutlet weak var switchFoodStatus: UISwitch!
    @IBOutlet weak var imgFood: UIImageView!
    
    var delegate: FoodItemCellActions?
        var foodItem: FoodItem?
        
        var rowIndex = 0
        
        class var reuseIdentifier: String {
            return "FoodItemCellReusable"
        }
        
        class var nibName: String {
            return "FoodTableViewCell"
        }
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
        func configXIB(foodItem: FoodItem, index: Int) {
            lblFoodName.text = foodItem.foodName
            lblFoodDescription.text = foodItem.foodDescription
            imgFood.kf.setImage(with: URL(string: foodItem.foodImgRes))
            lblFoodDiscount.text = "\(foodItem.discount)%"
            
            switchFoodStatus.isOn = foodItem.availability
            
            self.rowIndex = index
            self.foodItem = foodItem
        }
        
        @IBAction func onFoodStatusChanged(_ sender: UISwitch) {
            self.delegate?.onFoodItemStatusChanged(foodItem: self.foodItem!, status: sender.isOn)
        }
    }

    protocol FoodItemCellActions {
        func onFoodItemStatusChanged(foodItem: FoodItem, status: Bool)
    }
