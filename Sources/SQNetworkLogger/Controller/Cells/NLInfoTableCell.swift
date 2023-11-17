//
//  NLInfoTableCell.swift
//  Wilgood-iOS
//
//  Created by Ivan Mikhailovskii on 13.10.2020.
//  Copyright © 2020 Sequenia OOO. All rights reserved.
//

import UIKit

class NLInfoTableCell: UITableViewCell {

    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var methodLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.indicatorView.layer.cornerRadius = self.indicatorView.frame.width / 2.0
    }
    
    func bind(entity: SQNetworkRequestLog) {
        self.methodLabel.text = entity.method
        self.urlLabel.text = entity.url
        self.timeLabel.text = entity.date.formattedDate
        self.indicatorView.backgroundColor = entity.type.color
    }
    
}
