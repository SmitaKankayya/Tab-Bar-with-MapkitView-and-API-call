//
//  PopulationTableViewCell.swift
//  Webservices5_
//
//  Created by Smita Kankayya on 17/01/24.
//

import UIKit

class PopulationTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
