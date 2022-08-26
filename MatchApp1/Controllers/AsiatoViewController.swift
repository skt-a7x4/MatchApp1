//
//  AsiatoViewController.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/24.
//

import UIKit

class AsiatoViewController: MatchListViewController,GetAshiatoDataProtcol {
   
    

    var loadDBModel = LoadDBModel()
    var userDataModelArray = [UserDataModel]()
    
    
//　overrideとは上書き
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.navigationController?.isNavigationBarHidden = false
//        足跡をロードする
        
        loadDBModel.getAshiatoDataProtcol = self
        loadDBModel.loadAsiatoData()
        
        tableView.register(MatchPersonCell.nib(), forCellReuseIdentifier: MatchPersonCell.identifier)
        
    }
    
//   マッチした数と足跡の数は違うためここは記載しなければならない
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchPersonCell.identifier, for: indexPath) as? MatchPersonCell
        cell?.configure(nameLabelString: userDataModelArray[indexPath.row].name!, ageLabelString:userDataModelArray[indexPath.row].age! , workLabelString: userDataModelArray[indexPath.row].work!, quickWordLabelString: userDataModelArray[indexPath.row].quickWord!, profileImageViewString: userDataModelArray[indexPath.row].profileImageString!)
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC2") as! ProfileViewController
        profileVC.userDataModel = userDataModelArray[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func getAshiatoDataProtcol(userDataModelArray: [UserDataModel]) {
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
