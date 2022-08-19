//
//  LikeProfileCell.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/19.
//

import UIKit
import SDWebImage

class LikeProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var prefectureLabel: UILabel!
    @IBOutlet weak var quickWordLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var userData = [String:Any]()
    var uid = String()
    static let identifier = "LikeProfileCell"
    
    static func nib() ->UINib{
        
        return UINib(nibName: "LikeProfileCell", bundle: nil)
        
        
    }
    
    func configure(nameLabelString:String,ageLabelString:String,prefectureLabelString:String,bloodLabelString:String,genderLabelString:String,heightLabelString:String,workLabelString:String,quickWordLabelString:String,profileImageViewString:String,uid:String,userData:[String:Any]){
        
        
       
        nameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        prefectureLabel.text = prefectureLabelString
        bloodLabel.text = bloodLabelString
        genderLabel.text = genderLabelString
        heightLabel.text = heightLabelString
        workLabel.text = workLabelString
        quickWordLabel.text = quickWordLabelString
        profileImageView.sd_setImage(with: URL(string: profileImageViewString), completed: nil)
        self.uid = uid
        self.userData = userData
        
        Util.rectButton(button: likeButton)
       
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
