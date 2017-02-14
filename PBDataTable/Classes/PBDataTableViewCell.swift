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

            //If Last Column of the Cell is Button
            if  ApplicationDelegate.cellLastColumnButtonEnable == true && i == ApplicationDelegate.numberOfColumns-1 {
                let editBtn = UIButton(type: .custom)
                editBtn.frame = CGRect(x: labelXaxis, y: (self.frame.height-35)/2, width: 70,height: 35)
                editBtn.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0)
                editBtn.tag = 100+i
                editBtn.setTitle("Edit", for: UIControlState())
                self.contentView.addSubview(editBtn)
            }else {
                columnLbl.frame = CGRect(x: labelXaxis, y: 0, width: columnWidth,height: self.frame.height)
                columnLbl.textAlignment = .center
                columnLbl.font = UIFont(name: "Arial", size: 10)
                columnLbl.tag = 100+i
                columnLbl.adjustsFontSizeToFitWidth = true
                self.contentView.addSubview(columnLbl)
            }
            
            if i != ApplicationDelegate.numberOfColumns-1 {
                let innerBorderView = UIView()
                innerBorderView.frame = CGRect(x: columnLbl.frame.maxX-1, y: 0, width: 1, height: self.frame.height)
                innerBorderView.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0)
                innerBorderView.tag = 200+i
                self.contentView.addSubview(innerBorderView)
            }
            
            labelXaxis = labelXaxis + columnWidth
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
