//
//  NLInfoTableCell.swift
//  Wilgood-iOS
//
//  Created by Ivan Mikhailovskii on 13.10.2020.
//  Copyright © 2020 Sequenia OOO. All rights reserved.
//

import UIKit

class NLInfoTableCell: UITableViewCell {
    
    @IBOutlet private weak var methodLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bind(entity: SQNetworkError) {
        self.methodLabel.text = entity.method
        self.urlLabel.text = entity.url
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm, dd.MM.yy"
        
        self.timeLabel.text = formatter3.string(from: entity.date)
    }
    
}
