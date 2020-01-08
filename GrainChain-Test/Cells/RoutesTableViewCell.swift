//
//  RoutesTableViewCell.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 06/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import UIKit

class RoutesTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    //MARK: lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: public functions
    func configure(data: Dictionary<String, Any>) {
        let name = data[Route.NAME_KEY] as? String
        var distance: Double = 0
        let date = data[Route.START_DATE_KEY] as? Date
        let startDate = date?.currentDateToStringFormated(type: .full)
        
        if let currentDistance = data[Route.DISTANCE_KEY] as? Double {
            distance = currentDistance
        }
        
        nameLabel.text = "Name: \(name ?? "")"
        dateLabel.text = "Date: \(startDate ?? "")"
        distanceLabel.text = "Distance: \(distance.formateDistanceToString())"
    }
    
}
