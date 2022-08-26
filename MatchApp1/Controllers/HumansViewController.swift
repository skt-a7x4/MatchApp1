//
//  HumansViewController.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/18.
//

import UIKit
import Firebase
import SDWebImage

class HumansViewController: UIViewController,GetprofileDataProtocol,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    
    
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ashiatoButton: UIButton!
    
    var searchORNot = Bool()
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    let itemsPerRow:CGFloat = 2
    let db = Firestore.firestore()
    
    var userDataModelArray = [UserDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if Auth.auth().currentUser?.uid != nil && searchORNot == false {
            
            collectionView.delegate = self
            collectionView.dataSource = self
//            自分のユーザーデータを取り出す
            let userData = keyChainConfig.getKeyArrayData(key: "userData")
            
//            受信する
            let loadDBModel = LoadDBModel()
            loadDBModel.getprofileDataProtocol = self
            loadDBModel.loadUsersProfile(gender: userData["gender"] as! String)
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(Auth.auth().currentUser!.uid).setData(["gender":userData["gender"] as Any,"uid":userData["uid"] as Any,"age":userData["age"] as Any,"height":userData["height"] as Any,"profileImageString":userData["profileImageString"] as Any,"prefecture":userData["prefecture"] as Any,"name":userData["name"] as Any,"quickWord":userData["quickWord"] as Any,"profile":userData["profile"] as Any,"bloodType":userData["bloodType"] as Any,"work":userData["work"] as Any])
            
            loadDBModel.loadMatchingPersonData()
            
        }else if Auth.auth().currentUser?.uid != nil && searchORNot == true{
            
//            検索から返ってきたので、ロード
            collectionView.reloadData()
            
        }else{
            
            performSegue(withIdentifier: "inputVC", sender: nil)
            
        }
    }
    
    func getprofileData(userDataModelArray: [UserDataModel]) {
        self.userDataModelArray = userDataModelArray
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
//セルの構築
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        セルと構築、返す
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
//        セルに効果、影をつける
        cell.layer.cornerRadius = cell.frame.width/2
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = true
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: userDataModelArray[indexPath.row].profileImageString!), completed: nil)
        imageView.layer.cornerRadius = imageView.frame.width/2
        
        let ageLabel = cell.contentView.viewWithTag(2) as! UILabel
        ageLabel.text = userDataModelArray[indexPath.row].age
        
        let prefectureLabel = cell.contentView.viewWithTag(3) as! UILabel
        prefectureLabel.text = userDataModelArray[indexPath.row].prefecture
        
        let onLineMarkImageView = cell.contentView.viewWithTag(4) as! UIImageView
        onLineMarkImageView.layer.cornerRadius = onLineMarkImageView.frame.width/2
        
        if userDataModelArray[indexPath.row].onlineORNot == true {
            
            onLineMarkImageView.image = UIImage(named:"online")
        }else{
            
            onLineMarkImageView.image = UIImage(named:"offLine")
            
        }
        
        
        
        return cell
    }

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return userDataModelArray.count
   }
    
//    スクリーンに応じたセルにサイズを変える
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        print((itemsPerRow + 1) * sectionInsets.left)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
//    セルの行数
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
//    気になる人すなわちCell上の写真がタップされた際に画面遷移させるコード
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
// ProfileViewControllerに値を渡す為にここでデータを入れる
        profileVC.userDataModel = userDataModelArray[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
        
        
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
