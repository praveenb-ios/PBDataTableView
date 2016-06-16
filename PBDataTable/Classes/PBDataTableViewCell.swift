//
//  PBDataTableViewCell.swift
//  PBDataTable
//
//  Created by praveen b on 6/10/16.
//  Copyright © 2016 Praveen. All rights reserved.
//

import UIKit

class PBDataTableViewCell: UITableViewCell {
    var columnWidth: CGFloat = 80

    @IBOutlet var leftBorderView: UIView!
    @IBOutlet var rightBorderView: UIView!
    @IBOutlet var bottomBorderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var labelXaxis: CGFloat = 0
        
        for i in 0..<ApplicationDelegate.numberOfColumns {
            let columnLbl = UILabel()
            columnLbl.frame = CGRectMake(labelXaxis, 0, columnWidth,CGRectGetHeight(self.frame))
            columnLbl.textAlignment = .Center
            columnLbl.font = UIFont(name: "Arial", size: 10)
            columnLbl.tag = 100+i
            columnLbl.adjustsFontSizeToFitWidth = true
            self.contentView.addSubview(columnLbl)
            
            if i != ApplicationDelegate.numberOfColumns-1 {
                let innerBorderView = UIView()
                innerBorderView.frame = CGRectMake(CGRectGetMaxX(columnLbl.frame)-1, 0, 1, CGRectGetHeight(self.frame))
                innerBorderView.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0)
                innerBorderView.tag = 200+i
                self.contentView.addSubview(innerBorderView)
            }
            
            labelXaxis = labelXaxis + columnWidth
        }

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
