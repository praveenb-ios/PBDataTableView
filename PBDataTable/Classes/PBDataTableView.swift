//
//  PBDataTableView.swift
//  PBDataTable
//
//  Created by praveen b on 6/10/16.
//  Copyright © 2016 Praveen. All rights reserved.
//

import UIKit

protocol PBDataTableViewDelegate: class {
    func tableViewDidSelectedRow(_ indexPath: IndexPath)
    func tableViewCellEditButtonTapped(_ indexPath: IndexPath)
}

class PBDataTableView: UIView {

    @IBOutlet var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var searchBarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var headerVwTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var tableVwTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var scrollSuperViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var bgScrollView: UIScrollView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var noRecordLbl: UILabel!
    
    var filteredDataTableArray: NSMutableArray = NSMutableArray()
    var dataTableArray: NSMutableArray = NSMutableArray()
    var columnDataArray: NSMutableArray = NSMutableArray()
    
    var columnWidth: CGFloat = 80
    var totalColumnWidth: CGFloat = 0

    var enableSorting: Bool = true
    var enableCellOuterBorder: Bool = true
    var enableCellInnerBorder: Bool = true
    var enableSearchBar: Bool = true
    
    var shouldShowSearchResults = false

    var searchBarBackgroundColor: UIColor = UIColor(red: 246/255, green: 139/255, blue: 31/255, alpha: 1)
    var searchBarTxtFldFont: UIFont = UIFont(name: "Helvetica", size: 15)!
    var searchBarTxtFldTxtColor: UIColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
    var searchBarTxtFldBackgroundColor: UIColor = UIColor.clear
    var searchBarTxtFldPlaceholderColor: UIColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
    var searchBarTxtFldPlaceholder: String = "Search with First and Last name"
    var searchBarGlassIconTintColor: UIColor = UIColor.white
    var searchBarCancelBtnFont: UIFont = UIFont(name: "Helvetica", size: 15)!
    var searchBarCancelBtnColor: UIColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
    
    var lastColumnButtonHeaderName = "Edit"

    var delegate: PBDataTableViewDelegate!
    
    //Setup the tableview with number of Columns and Rows
    func setupView() {
        
        //To Calculate total width of the header view
        for eachHeader in columnDataArray {
            let eachLblWidth = CGFloat((eachHeader as AnyObject).object(forKey: "widthSize") as! NSNumber)
            totalColumnWidth = eachLblWidth + totalColumnWidth
        }
        
        if ApplicationDelegate.cellLastColumnButtonEnable == true {
            totalColumnWidth = totalColumnWidth + 80
            ApplicationDelegate.numberOfColumns = columnDataArray.count + 1
        }else {
            ApplicationDelegate.numberOfColumns = columnDataArray.count
        }
        
        if enableSearchBar {
            searchBarCustomizeView()
            searchBar.isHidden = false
            searchBarHeightConstraint.constant = 44
        }else {
            searchBar.isHidden = true
            searchBarHeightConstraint.constant = 0
        }
        //Create Header View for Tableview
        self.createTableHeaderView()
        
        let nib = UINib(nibName: "PBDataTableViewCell", bundle: nil)
        dataTableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    //Customize the Search bar
    func searchBarCustomizeView() {
        // To get a pure color
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = searchBarBackgroundColor
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = searchBarTxtFldTxtColor
        textFieldInsideSearchBar?.font = searchBarTxtFldFont
        textFieldInsideSearchBar?.backgroundColor = searchBarTxtFldBackgroundColor
        textFieldInsideSearchBar?.tintColor = UIColor.black
        textFieldInsideSearchBar?.placeholder = searchBarTxtFldPlaceholder
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = searchBarTxtFldPlaceholderColor
        
        if let glassIconView = textFieldInsideSearchBar!.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            glassIconView.tintColor = searchBarGlassIconTintColor
            
        }
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.classForCoder() as! UIAppearanceContainer.Type])
            .setTitleTextAttributes([
                NSFontAttributeName: searchBarCancelBtnFont,
                NSForegroundColorAttributeName: searchBarCancelBtnColor
                ],for: UIControlState())
    }
    
    //Check the total width and re-size the scrollview.superview width by changing the Trailing Constraint

    func configureView() {
        if totalColumnWidth > self.frame.width {
            scrollSuperViewTrailingConstraint.constant = (bgScrollView.frame.width-totalColumnWidth)
            searchBarTrailingConstraint.constant = 0

            self.updateConstraints()
            self.layoutIfNeeded()
            
            bgScrollView.contentSize = CGSize(width: bgScrollView.frame.width-scrollSuperViewTrailingConstraint.constant, height: self.frame.height-searchBarHeightConstraint.constant)
            dataTableView.reloadData()
        }else {
            tableVwTrailingConstraint.constant = (bgScrollView.frame.width - totalColumnWidth)
            headerVwTrailingConstraint.constant = tableVwTrailingConstraint.constant
            searchBarTrailingConstraint.constant = tableVwTrailingConstraint.constant

            self.updateConstraints()
            self.layoutIfNeeded()

        }
    }
    
    func createTableHeaderView() {
        var headerCount = 0
        var headerLblXaxis: CGFloat = 0
        
        for eachHeader in columnDataArray {
            
            let eachLblWidth = CGFloat((eachHeader as AnyObject).object(forKey: "widthSize") as! NSNumber)
            
            //Header Label
            let columnHeaderLbl = UILabel()
            columnHeaderLbl.text = (eachHeader as AnyObject).object(forKey: "name") as? String
            columnHeaderLbl.textAlignment = .center
            columnHeaderLbl.font = UIFont(name: "Arial", size: 14)
            columnHeaderLbl.tag = 1000+headerCount
            columnHeaderLbl.textColor = UIColor.white
            columnHeaderLbl.adjustsFontSizeToFitWidth = true
            tableHeaderView.addSubview(columnHeaderLbl)

            if enableSorting {
                columnHeaderLbl.frame = CGRect(x: headerLblXaxis, y: 0, width: eachLblWidth-25, height: tableHeaderView.frame.height)

                //Header Sort ImageView
                let sortImg = UIImageView(image: UIImage(named: "none"))
                sortImg.accessibilityIdentifier = "0"
                
                sortImg.frame = CGRect(x: columnHeaderLbl.frame.maxX+5, y: (tableHeaderView.frame.height-sortImg.image!.size.height)/2, width: sortImg.image!.size.width, height: sortImg.image!.size.height)
                sortImg.tag = 2000+headerCount
                tableHeaderView.addSubview(sortImg)
                
                //Header Button to Sort the rows on tap
                let headerBtn = UIButton(type: .custom)
                headerBtn.frame = CGRect(x: columnHeaderLbl.frame.minX, y: 0, width: eachLblWidth, height: columnHeaderLbl.frame.height)
                headerBtn.backgroundColor = UIColor.clear
                headerBtn.addTarget(self, action: #selector(headerColumnBtnTapped), for: .touchUpInside)
                headerBtn.tag = 3000+headerCount
                tableHeaderView.addSubview(headerBtn)
            }else {
                columnHeaderLbl.frame = CGRect(x: headerLblXaxis, y: 0, width: eachLblWidth, height: tableHeaderView.frame.height)
            }
            headerLblXaxis = eachLblWidth + headerLblXaxis
            headerCount += 1
        }
        
        //Add Edit Button On Header
        if ApplicationDelegate.cellLastColumnButtonEnable == true {
            let editButton = UILabel()
            editButton.text = lastColumnButtonHeaderName
            editButton.textAlignment = .center
            editButton.font = UIFont(name: "Arial", size: 14)
            editButton.textColor = UIColor.white
            editButton.adjustsFontSizeToFitWidth = true
            tableHeaderView.addSubview(editButton)
            editButton.frame = CGRect(x: headerLblXaxis, y: 0, width: 70, height: tableHeaderView.frame.height)
        }
    }
    
    func editBtnTapped(_ sender: UIButton) {
        let btnPosition = sender.convert(CGPoint.zero, to: dataTableView)
        let selectedIndex = dataTableView.indexPathForRow(at: btnPosition)
        
        delegate.tableViewCellEditButtonTapped(selectedIndex!)
    }
    
    func headerColumnBtnTapped(_ sender: UIButton) {
        for i in 0..<ApplicationDelegate.numberOfColumns {
            if sender.tag == i+3000 {
                let headerSortImg = sender.superview!.viewWithTag(2000+i) as? UIImageView

                if ((headerSortImg!.accessibilityIdentifier == "0") || (headerSortImg!.accessibilityIdentifier == "2")) {
                    headerSortImg?.image = UIImage(named: "ascending")
                    headerSortImg?.accessibilityIdentifier = "1"
                    
                    //To Sort the table data Array in Ascending Order, respect to the Column header Tapped
                    sortingDataTableArray(headerSortImg!.tag-2000, boolValue: true)
                }else {
                    headerSortImg?.image = UIImage(named: "descending")
                    headerSortImg?.accessibilityIdentifier = "2"
                    
                    //To Sort the table data Array in Decending Order, respect to the Column header Tapped
                    sortingDataTableArray(headerSortImg!.tag-2000, boolValue: false)
                }
            }else {
                let headerSortImg = sender.superview!.viewWithTag(2000+i) as? UIImageView
                headerSortImg?.image = UIImage(named: "none")
                headerSortImg?.accessibilityIdentifier = "0"

            }
        }
    }
    
    //MARK: - Sorting Method
    func sortingDataTableArray(_ intValue: Int, boolValue: Bool) {
        let sort = NSSortDescriptor(key: "rowColumn\(intValue+1)", ascending:boolValue)
        if shouldShowSearchResults {
            filteredDataTableArray.sort(using: [sort])
        }else {
            dataTableArray.sort(using: [sort])
        }
        dataTableView.reloadData()
    }
}

//MARK: - TableView DataSource
extension PBDataTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            if filteredDataTableArray.count > 0 {
                noRecordLbl.isHidden = true
                dataTableView.isHidden = false
            }else {
                noRecordLbl.isHidden = false
                dataTableView.isHidden = true
            }
            return filteredDataTableArray.count
        }else {
            if dataTableArray.count > 0 {
                noRecordLbl.isHidden = true
                dataTableView.isHidden = false
            }else {
                noRecordLbl.isHidden = false
                dataTableView.isHidden = true
            }
            return dataTableArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PBDataTableViewCell
        
        cell.backgroundColor = UIColor.white
        configureCell(cell, indexPath: indexPath)
        
        if enableCellOuterBorder {
            cell.leftBorderView.isHidden = false
            cell.rightBorderView.isHidden = false
            cell.bottomBorderView.isHidden = false
        }else {
            cell.leftBorderView.isHidden = true
            cell.rightBorderView.isHidden = true
            cell.bottomBorderView.isHidden = true
        }
        return cell
    }
    
    //Configure Tableview Cells with Defined Label
    func configureCell(_ cell: PBDataTableViewCell, indexPath: IndexPath) {
        let columnDict: NSDictionary!
        
        if shouldShowSearchResults {
            columnDict = filteredDataTableArray.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        }else {
            columnDict = dataTableArray.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        }
        var labelXaxis: CGFloat = 0
        
        for i in 0..<ApplicationDelegate.numberOfColumns {
            var columnLbl: UILabel!
            var columnBtn: UIButton!
            
            if i == ApplicationDelegate.numberOfColumns-1 && ApplicationDelegate.cellLastColumnButtonEnable == true {
                columnBtn = cell.contentView.viewWithTag(100+i) as? UIButton
                columnBtn.addTarget(self, action: #selector(editBtnTapped(_:)), for: .touchUpInside)
                
                var rect = columnBtn!.frame
                rect.origin.x = labelXaxis+5
                rect.size.width = columnBtn.frame.width
                columnBtn!.frame = rect
                
            }else {
                columnLbl = cell.contentView.viewWithTag(100+i) as? UILabel
                var rect = columnLbl!.frame
                rect.origin.x = labelXaxis
                
                if case let eachArray as NSDictionary = columnDataArray.object(at: i) {
                    rect.size.width = CGFloat(eachArray.object(forKey: "widthSize") as! NSNumber)
                }
                
                columnLbl!.frame = rect
                columnLbl!.text = String(describing: columnDict.object(forKey: "rowColumn\(i+1)")!)
                
                labelXaxis = labelXaxis + (columnLbl?.frame)!.width
            }
            
            let innerLine = cell.contentView.viewWithTag(200+i)
            if enableCellInnerBorder {
                innerLine?.frame = CGRect(x: columnLbl!.frame.maxX-1, y: 0, width: 1, height: cell.frame.height)
                innerLine?.isHidden = false
            }else {
                innerLine?.isHidden = true
            }
        }
    }
}

//MARK: - TableView Delegate
extension PBDataTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.tableViewDidSelectedRow(indexPath)
    }
}

//MARK: - Search Bar Delegate
extension PBDataTableView: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        shouldShowSearchResults = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        dataTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            dataTableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            shouldShowSearchResults = false
        }else {
            shouldShowSearchResults = true
            //filtered with firstname and last name. Give the column names respectively to be sorted
            let results = dataTableArray.filter({ person in
                let personDict = person as! NSDictionary
                if let firstname = personDict["rowColumn1"] as? String, let lastname = personDict["rowColumn2"] as? String, let query = searchBar.text {
                    return firstname.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil || lastname.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
                }
                return false
            })
            filteredDataTableArray = NSMutableArray(array: results)
        }
        dataTableView.reloadData()
    }
}
