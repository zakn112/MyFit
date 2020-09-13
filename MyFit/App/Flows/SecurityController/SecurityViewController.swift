//
//  SecurityViewController.swift
//  MyFit
//
//  Created by Андрей Закусов on 13.09.2020.
//  Copyright © 2020 Андрей Закусов. All rights reserved.
//

import UIKit

class SecurityViewController: UIViewController {
    
    var logoImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.image = #imageLiteral(resourceName: "MyFit")
        let frame = CGRect(x: self.view.bounds.size.width/2 - 100, y: self.view.bounds.size.height/2 - 100, width: 200, height: 200)
        logoImageView.frame = frame
        self.view.addSubview(logoImageView)
        
        self.view.backgroundColor = .white
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
