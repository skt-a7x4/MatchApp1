//
//  ProfileImageCell.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/19.
//

import UIKit
import SDWebImage

class ProfileImageCell: UITableViewCell {

    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var prefectureLabel: UILabel!
    @IBOutlet weak var quickWordLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    
    
    static let identifile = "ProfileImageCell"
    
    static func nib() ->UINib{
        
        return UINib(nibName: "ProfileImageCell", bundle: nil)
        
        
    }
    
    func configure(profileImageString:String,nameLabelString:String,ageLabelString:String,prefectureLabelString:String,quickWordLabelString:String,LikeLabelString:String){
        
        
        profileImageView.sd_setImage(with: URL(string: profileImageString), completed: nil)
        nameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        prefectureLabel.text = prefectureLabelString
        quickWordLabel.text = quickWordLabelString
        LikeLabel.text = LikeLabelString
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
