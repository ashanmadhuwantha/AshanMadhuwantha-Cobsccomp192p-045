//
//  CategoryCollectionViewCell.swift
//  AshanMadhuwantha-Cobsccomp192p-045
//
//  Created by Ashan Madhuwantha on 2021-04-30.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCategoryName: UILabel!
    class var reuseIdentifier: String {
        return "CategoryCollectionCellReusable"
    }
    
    class var nibName: String {
        return "CategoryCollectionViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configXIB(category: Category) {
        lblCategoryName.text = category.categoryName
        
    }
}
