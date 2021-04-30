//
//  CategoryTableViewCell.swift
//  AshanMadhuwantha-Cobsccomp192p-045
//
//  Created by Ashan Madhuwantha on 2021-04-30.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCategoryName: UILabel!
    
    class var reuseIdentifier: String {
        return "CategoryReusable"
    }
    
    class var nibName: String {
        return "CategoryTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configXIB(category: Category) {
        lblCategoryName.text = category.categoryName
    }
    
}
