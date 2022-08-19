//
//  ProfielDetailCell.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/19.
//

import UIKit

class ProfielDetailCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var prefectureLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    
    
    static let identifile = "ProfielDetailCell"
    
    static func nib() ->UINib{
        
        return UINib(nibName: "ProfielDetailCell", bundle: nil)
        
        
    }
    
    func configure(nameLabelString:String,ageLabelString:String,prefectureLabelString:String,bloodLabelString:String,genderLabelString:String,heightLabelString:String,workLabelString:String){
        
        
       
        nameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        prefectureLabel.text = prefectureLabelString
        bloodLabel.text = bloodLabelString
        genderLabel.text = genderLabelString
        heightLabel.text = heightLabelString
        workLabel.text = workLabelString
       
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
