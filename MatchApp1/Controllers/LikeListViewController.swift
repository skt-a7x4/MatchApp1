//
//  LikeListViewController.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/19.
//

import UIKit

class LikeListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetLikeDataProtocol {
    
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var userDataModelArray = [UserDataModel]()
    var userData = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LikeProfileCell.nib(), forCellReuseIdentifier: LikeProfileCell.identifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        let loadDBModel = LoadDBModel()
        loadDBModel.getLikeDataProtocol = self
        
//        likeに入っている人達の情報を取得しcellへ表示する
        loadDBModel.loadLikeList()
        userData = keyChainConfig.getKeyArrayData(key: "userData")
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeProfileCell.identifier, for: indexPath) as! LikeProfileCell
        
        cell.configure(nameLabelString: userDataModelArray[indexPath.row].name!, ageLabelString: userDataModelArray[indexPath.row].age!, prefectureLabelString: userDataModelArray[indexPath.row].prefecture!, bloodLabelString: userDataModelArray[indexPath.row].bloodType!, genderLabelString: userDataModelArray[indexPath.row].gender!, heightLabelString: userDataModelArray[indexPath.row].height!, workLabelString: userDataModelArray[indexPath.row].work!, quickWordLabelString: userDataModelArray[indexPath.row].quickWord!, profileImageViewString: userDataModelArray[indexPath.row].profileImageString!, uid: userDataModelArray[indexPath.row].uid!, userData: userData)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func getLikeDataProtocol(userDataModelArray: [UserDataModel]) {
        self.userDataModelArray = []
        self.userDataModelArray = userDataModelArray
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
