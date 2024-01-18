//
//  ProfileVC.swift
//  Webservices5_
//
//  Created by Smita Kankayya on 17/01/24.
//

import UIKit
import Kingfisher

class ProfileVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
       bindData()
    }
    
    func  bindData(){
        let assetName = "girldp"
        if let image = UIImage(named: assetName){
            imageView.image = image
        }
        self.nameLabel.text = ("Name: \("Smita Kankayya")")
        self.phoneNumberLabel.text = ("Phone Number: \(String(9890111222))")
        
    }
    

   

}
