//
//  BaseFadeInViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/5.
//

import UIKit

class BaseFadeInViewController: BaseViewController {

    override func configure() {
        super.configure()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        modalPresentationStyle = .overCurrentContext
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
