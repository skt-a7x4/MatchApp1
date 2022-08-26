//
//  MatchListViewController.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/24.
//

import UIKit
import Firebase

class MatchListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetWhoisMatchListProtocol {
    
    
    
    
    
    var tableView = UITableView()
    var matchingArray = [UserDataModel]()
    var userData = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MatchPersonCell.nib(), forCellReuseIdentifier: MatchPersonCell.identifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        マッチングしているデータを取得
        let loadDBModel = LoadDBModel()
        loadDBModel.getWhoisMatchListProtocol = self
        loadDBModel.loadMatchingPersonData()
        userData = keyChainConfig.getKeyArrayData(key: "userData")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchPersonCell.identifier, for: indexPath) as! MatchPersonCell
        cell.configure(nameLabelString: matchingArray[indexPath.row].name!, ageLabelString: matchingArray[indexPath.row].age!, workLabelString: matchingArray[indexPath.row].work!, quickWordLabelString: matchingArray[indexPath.row].quickWord!, profileImageViewString: matchingArray[indexPath.row].profileImageString!)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = self.storyboard?.instantiateViewController(identifier: "chatVC") as! ChatViewController
        
        chatVC.userDataModel = matchingArray[indexPath.row]
        chatVC.userData = userData
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func getWhoisMatchListProtocol(userDataModelArray: [UserDataModel]) {
        matchingArray = userDataModelArray
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
