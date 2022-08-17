//
//  CreateNewUsersViewController.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/17.
//

import UIKit

class CreateNewUsersViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var quickWordTextField: UITextField!
    
    @IBOutlet weak var toProfileButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
//    年齢や身長、血液型、居住地をドラムロールしたいのでUIPickerView()を使う
    var agepicker = UIPickerView()
    var heightpicker = UIPickerView()
    var bloodpicker = UIPickerView()
    var prefecturepicker = UIPickerView()
    
// 文字すなわち居住地や血液型など
    var dataStringArray = [String]()
//   数字が入る場合はInt型
    var dataIntArray = [Int]()
   
//    男性のまま決定を押すと決定ボタンが入力できないのでgenderに男性を入れるため作成
    var gender = String()

    override func viewDidLoad() {
        super.viewDidLoad()
//        どのPickerがどのtextなのかを紐付けするためにinputViewを使う
        textField2.inputView = agepicker
        textField3.inputView = heightpicker
        textField4.inputView = bloodpicker
        textField5.inputView = prefecturepicker
        
        agepicker.delegate = self
        agepicker.dataSource = self
        agepicker.tag = 1
        
        heightpicker.delegate = self
        heightpicker.dataSource = self
        heightpicker.tag = 2
        
        bloodpicker.delegate = self
        bloodpicker.dataSource = self
        bloodpicker.tag = 3
        
        prefecturepicker.delegate = self
        prefecturepicker.dataSource = self
        prefecturepicker.tag = 4
       
        gender = "男性"
        
        Util.rectButton(button: toProfileButton)
        Util.rectButton(button: doneButton)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
//    行数を決める
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        年齢を選択するとドラムロールにて18歳から80歳までをドラムロールしてくれる
        switch pickerView.tag {
        case 1:
            dataIntArray = ([Int])(18...80)
//　18から80歳までの行数を返してくれるという意味
            return dataIntArray.count
        case 2:
            dataIntArray = ([Int])(140...200)
//　140から200cmまでの行数を返してくれるという意味
            return dataIntArray.count
        case 3:
            
            dataStringArray = ["A型","B型","O型","AB型"]
//　A型からAB型までの行数を返してくれるという意味
            return dataStringArray.count
        case 4:
            dataStringArray = Util.prefectures()
//　都道府県までの行数を返してくれるという意味
            return dataStringArray.count
        default:
            return 0
        }
    }
//    キーボードを閉じたい,またはpickerを閉じたい場合にする処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
//           歳がString型になってしまう為dataIntArrayの前に()をつけて()の前にStringを記載する。※Int型は数字のためString型とInt型は足すことができないため型を合わせる
            textField2.text = String(dataIntArray[row]) + "歳"
            textField2.resignFirstResponder()
            break
        case 2:
//           歳がString型になってしまう為dataIntArrayの前に()をつけて()の前にStringを記載する。※Int型は数字のためString型とInt型は足すことができないため型を合わせる
            textField3.text = String(dataIntArray[row]) + "cm"
            textField3.resignFirstResponder()
            break
        case 3:

            textField4.text = dataStringArray[row] + "型"
            textField4.resignFirstResponder()
            break
        case 4:

            textField5.text = dataStringArray[row]
            textField5.resignFirstResponder()
            break
        default:
            break
        }
    }
//    行に記載する文字列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return String(dataIntArray[row]) + "歳"
        case 2:
            return String(dataIntArray[row]) + "cm"
        case 3:
            return dataStringArray[row] + "型"
        case 4:
            return dataStringArray[row]
        default:
            return ""
        }
    }
    
    
    @IBAction func genderSwitch(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            gender = "男性"
        }else{
            
            gender = "女性"
            
        }
    }
    
    @IBAction func done(_ sender: Any) {
//        fireStoreに値を送信する
        let manager = Manager.shared
        
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
