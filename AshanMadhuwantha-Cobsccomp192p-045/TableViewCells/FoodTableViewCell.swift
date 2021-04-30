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
       
        
    }
}
