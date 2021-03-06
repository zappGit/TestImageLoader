//
//  CustomTableViewCell.swift
//  TestImageLoader
//
//  Created by Артем Хребтов on 28.08.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellDesc: UILabel!
//Кастомная ячейка
    var cellID: Int = 0
    var image: UIImage? {
        didSet{
            cellImage.image = image
        }
    }
    var desc: String? {
        didSet {
           cellDesc.text = desc
        }
    }
}
