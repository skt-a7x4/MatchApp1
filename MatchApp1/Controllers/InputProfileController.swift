//
//  InputProfileController.swift
//  MatchApp1
//
//  Created by 酒匂竜也 on 2022/08/17.
//

import UIKit

class InputProfileController: UIViewController {

    @IBOutlet weak var profileTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Util.rectButton(button: doneButton)

        // Do any additional setup after loading the view.
    }
    @IBAction func done(_ sender: Any) {
        
        let manager = Manager.shared
        print(manager.profile)
        manager.profile = profileTextView.text
        dismiss(animated: true, completion: nil)
        
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
