//
//  ProfileViewController.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/19.
//
// HumansViewControllerでタップされた時にデータ(値)を渡すためのcontroller
import UIKit
import Firebase

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LikeSendDelegate,GetLikeCountProtocol {
  
    
    
    
    
    var likeCount = Int()
    var likeFlag = Bool()
    var loadDBModel = LoadDBModel()
    
    

    var userDataModel:UserDataModel?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
//        ここでカスタムセルを登録する
        tableView.register(ProfileImageCell.nib(), forCellReuseIdentifier: ProfileImageCell.identifile)
        tableView.register(ProfileTextCell.nib(), forCellReuseIdentifier: ProfileTextCell.identifile)
        tableView.register(ProfielDetailCell.nib(), forCellReuseIdentifier: ProfielDetailCell.identifile)

        loadDBModel.getLikeCountProtocol = self
        loadDBModel.loadLikeCount(uuid: (userDataModel?.uid)!)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        let sendDBModel = SendDBModel()
        sendDBModel.sendAshiato(aitenoUserID: (userDataModel?.uid)!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageCell.identifile, for: indexPath) as! ProfileImageCell
            
            cell.configure(profileImageString: (userDataModel?.profileImageString)!, nameLabelString: (userDataModel?.name)!, ageLabelString: (userDataModel?.age)!, prefectureLabelString: (userDataModel?.prefecture)!, quickWordLabelString: (userDataModel?.quickWord)!, LikeLabelString:String(likeCount) )
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextCell.identifile, for: indexPath) as! ProfileTextCell
            
            cell.profileTextView.text = userDataModel?.profile
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfielDetailCell.identifile, for: indexPath) as! ProfielDetailCell
            
            cell.configure(nameLabelString: (userDataModel?.name)!, ageLabelString: (userDataModel?.age)!, prefectureLabelString: (userDataModel?.prefecture)!, bloodLabelString: (userDataModel?.bloodType)!, genderLabelString: (userDataModel?.gender)!, heightLabelString: (userDataModel?.height)!, workLabelString: (userDataModel?.work)!)
            
            return cell
            
        default:
            return UITableViewCell()
            
        }
        
            }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            
            return 450
            
        }else if indexPath.row == 2{
            
            return 370
            
            
        }else if indexPath.row == 3 {
            
            return 400
            
        }
        
        return 1
    }
    
    
    @IBAction func likeActin(_ sender: Any) {
        
//        もし自分のIDではない場合
        if userDataModel?.uid != Auth.auth().currentUser?.uid{
            
//           likeをする
            let sendDBModel = SendDBModel()
            sendDBModel.likeSendDelegate = self
            
            if self.likeFlag == false {
                
                sendDBModel.sendToLike(likeFlag: true, thisUserID: (userDataModel?.uid)!)
                
            }else {
                
                sendDBModel.sendToLike(likeFlag: false, thisUserID: (userDataModel?.uid)!)
                
                
            }
            
           
            
        }
        
        
    }
    
    func like() {
//        likeが押されたときにハートのアニメーションを作りたい
        Util.startAnimation(name: "heart", view: self.view)
    }
    
    func getLikeCount(likeCount: Int, likeFlag: Bool) {
        self .likeFlag = likeFlag
        self.likeCount = likeCount
        if self.likeFlag == false {
            
            likeButton.setImage(UIImage(named: "notLike"), for: .normal)
        }else{
            
            likeButton.setImage(UIImage(named: "like"), for: .normal)
            
        }
        
        tableView.reloadData()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
