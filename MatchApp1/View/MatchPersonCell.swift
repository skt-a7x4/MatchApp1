//
//  MatchPersonCell.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/24.
//

import UIKit

class MatchPersonCell: UITableViewCell {
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    
    
    static let identifier = "MatchPersonCell"
    
    static func nib() ->UINib{
        
        return UINib(nibName: "MatchPersonCell", bundle: nil)
    }
    
    func configure(nameLabelString:String,ageLabelString:String,workLabelString:String,quickWordLabelString:String,profileImageViewString:String){
        
        
       
        userNameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        workLabel.text = workLabelString
        profileImageView.sd_setImage(with: URL(string: profileImageViewString), completed: nil)
       
       
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
