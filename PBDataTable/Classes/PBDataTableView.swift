//
//  PBDataTableView.swift
//  PBDataTable
//
//  Created by praveen b on 6/10/16.
//  Copyright © 2016 Praveen. All rights reserved.
//

import UIKit

protocol PBDataTableViewDelegate: class {
    func tableViewDidSelectedRow(indexPath: NSIndexPath)
    func tableViewCellEditButtonTapped(indexPath: NSIndexPath)
}

class PBDataTableView: UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate , UISearchControllerDelegate{

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
    var searchBarTxtFldBackgroundColor: UIColor = UIColor.clearColor()
    var searchBarTxtFldPlaceholderColor: UIColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
    var searchBarTxtFldPlaceholder: String = "Search with First and Last name"
    var searchBarGlassIconTintColor: UIColor = UIColor.whiteColor()
    var searchBarCancelBtnFont: UIFont = UIFont(name: "Helvetica", size: 15)!
    var searchBarCancelBtnColor: UIColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
    
    var lastColumnButtonHeaderName = "Edit"

    var delegate: PBDataTableViewDelegate!
    
    //Setup the tableview with number of Columns and Rows
    func setupView() {
        
        //To Calculate total width of the header view
        for eachHeader in columnDataArray {
            let eachLblWidth = CGFloat(eachHeader.objectForKey("widthSize") as! NSNumber)
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
            searchBar.hidden = false
            searchBarHeightConstraint.constant = 44
        }else {
            searchBar.hidden = true
            searchBarHeightConstraint.constant = 0
        }
        //Create Header View for Tableview
        self.createTableHeaderView()
        
        let nib = UINib(nibName: "PBDataTableViewCell", bundle: nil)
        dataTableView.registerNib(nib, forCellReuseIdentifier: "Cell")
    }
    
    //Customize the Search bar
    func searchBarCustomizeView() {
        // To get a pure color
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = searchBarBackgroundColor
        
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = searchBarTxtFldTxtColor
        textFieldInsideSearchBar?.font = searchBarTxtFldFont
        textFieldInsideSearchBar?.backgroundColor = searchBarTxtFldBackgroundColor
        textFieldInsideSearchBar?.tintColor = UIColor.blackColor()
        textFieldInsideSearchBar?.placeholder = searchBarTxtFldPlaceholder
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.valueForKey("placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = searchBarTxtFldPlaceholderColor
        
        if let glassIconView = textFieldInsideSearchBar!.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            glassIconView.tintColor = searchBarGlassIconTintColor
            
        }
        
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.classForCoder()])
            .setTitleTextAttributes([
                NSFontAttributeName: searchBarCancelBtnFont,
                NSForegroundColorAttributeName: searchBarCancelBtnColor
                ],forState: UIControlState.Normal)
    }
    
    //Check the total width and re-size the scrollview.superview width by changing the Trailing Constraint

    func configureView() {
        if totalColumnWidth > CGRectGetWidth(self.frame) {
            scrollSuperViewTrailingConstraint.constant = (CGRectGetWidth(bgScrollView.frame)-totalColumnWidth)
            searchBarTrailingConstraint.constant = 0

            self.updateConstraints()
            self.layoutIfNeeded()
            
            bgScrollView.contentSize = CGSizeMake(CGRectGetWidth(bgScrollView.frame)-scrollSuperViewTrailingConstraint.constant, CGRectGetHeight(self.frame)-searchBarHeightConstraint.constant)
            dataTableView.reloadData()
        }else {
            tableVwTrailingConstraint.constant = (CGRectGetWidth(bgScrollView.frame) - totalColumnWidth)
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
            
            let eachLblWidth = CGFloat(eachHeader.objectForKey("widthSize") as! NSNumber)
            
            //Header Label
            let columnHeaderLbl = UILabel()
            columnHeaderLbl.text = eachHeader.objectForKey("name") as? String
            columnHeaderLbl.textAlignment = .Center
            columnHeaderLbl.font = UIFont(name: "Arial", size: 14)
            columnHeaderLbl.tag = 1000+headerCount
            columnHeaderLbl.textColor = UIColor.whiteColor()
            columnHeaderLbl.adjustsFontSizeToFitWidth = true
            tableHeaderView.addSubview(columnHeaderLbl)

            if enableSorting {
                columnHeaderLbl.frame = CGRectMake(headerLblXaxis, 0, eachLblWidth-25, CGRectGetHeight(tableHeaderView.frame))

                //Header Sort ImageView
                let sortImg = UIImageView(image: UIImage(named: "none"))
                sortImg.accessibilityIdentifier = "0"
                
                sortImg.frame = CGRectMake(CGRectGetMaxX(columnHeaderLbl.frame)+5, (CGRectGetHeight(tableHeaderView.frame)-sortImg.image!.size.height)/2, sortImg.image!.size.width, sortImg.image!.size.height)
                sortImg.tag = 2000+headerCount
                tableHeaderView.addSubview(sortImg)
                
                //Header Button to Sort the rows on tap
                let headerBtn = UIButton(type: .Custom)
                headerBtn.frame = CGRectMake(CGRectGetMinX(columnHeaderLbl.frame), 0, eachLblWidth, CGRectGetHeight(columnHeaderLbl.frame))
                headerBtn.backgroundColor = UIColor.clearColor()
                headerBtn.addTarget(self, action: #selector(headerColumnBtnTapped), forControlEvents: .TouchUpInside)
                headerBtn.tag = 3000+headerCount
                tableHeaderView.addSubview(headerBtn)
            }else {
                columnHeaderLbl.frame = CGRectMake(headerLblXaxis, 0, eachLblWidth, CGRectGetHeight(tableHeaderView.frame))
            }
            headerLblXaxis = eachLblWidth + headerLblXaxis
            headerCount += 1
        }
        
        //Add Edit Button On Header
        if ApplicationDelegate.cellLastColumnButtonEnable == true {
            let editButton = UILabel()
            editButton.text = lastColumnButtonHeaderName
            editButton.textAlignment = .Center
            editButton.font = UIFont(name: "Arial", size: 14)
            editButton.textColor = UIColor.whiteColor()
            editButton.adjustsFontSizeToFitWidth = true
            tableHeaderView.addSubview(editButton)
            editButton.frame = CGRectMake(headerLblXaxis, 0, 70, CGRectGetHeight(tableHeaderView.frame))
        }
    }
    
    //MARK: - TableView DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            if filteredDataTableArray.count > 0 {
                noRecordLbl.hidden = true
                dataTableView.hidden = false
            }else {
                noRecordLbl.hidden = false
                dataTableView.hidden = true
            }
            return filteredDataTableArray.count
        }else {
            if dataTableArray.count > 0 {
                noRecordLbl.hidden = true
                dataTableView.hidden = false
            }else {
                noRecordLbl.hidden = false
                dataTableView.hidden = true
            }
            return dataTableArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PBDataTableViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        configureCell(cell, indexPath: indexPath)
        
        if enableCellOuterBorder {
            cell.leftBorderView.hidden = false
            cell.rightBorderView.hidden = false
            cell.bottomBorderView.hidden = false
        }else {
            cell.leftBorderView.hidden = true
            cell.rightBorderView.hidden = true
            cell.bottomBorderView.hidden = true
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate.tableViewDidSelectedRow(indexPath)
    }
    
    //Configure Tableview Cells with Defined Label
    func configureCell(cell: PBDataTableViewCell, indexPath: NSIndexPath) {
        let columnDict: NSDictionary!
        
        if shouldShowSearchResults {
            columnDict = filteredDataTableArray.objectAtIndex(indexPath.row) as! NSDictionary
        }else {
            columnDict = dataTableArray.objectAtIndex(indexPath.row) as! NSDictionary
        }
        var labelXaxis: CGFloat = 0

        for i in 0..<ApplicationDelegate.numberOfColumns {
            var columnLbl: UILabel!
            var columnBtn: UIButton!

            if i == ApplicationDelegate.numberOfColumns-1 && ApplicationDelegate.cellLastColumnButtonEnable == true {
                columnBtn = cell.contentView.viewWithTag(100+i) as? UIButton
                columnBtn.addTarget(self, action: #selector(editBtnTapped(_:)), forControlEvents: .TouchUpInside)
                
                var rect = columnBtn!.frame
                rect.origin.x = labelXaxis+5
                rect.size.width = CGRectGetWidth(columnBtn.frame)
                columnBtn!.frame = rect
                
            }else {
                columnLbl = cell.contentView.viewWithTag(100+i) as? UILabel
                var rect = columnLbl!.frame
                rect.origin.x = labelXaxis
                rect.size.width = CGFloat(columnDataArray.objectAtIndex(i).objectForKey("widthSize") as! NSNumber)
                columnLbl!.frame = rect
                columnLbl!.text = String(columnDict.objectForKey("rowColumn\(i+1)")!)
                
                labelXaxis = labelXaxis + CGRectGetWidth((columnLbl?.frame)!)
            }

            let innerLine = cell.contentView.viewWithTag(200+i)
            if enableCellInnerBorder {
                innerLine?.frame = CGRectMake(CGRectGetMaxX(columnLbl!.frame)-1, 0, 1, CGRectGetHeight(cell.frame))
                innerLine?.hidden = false
            }else {
                innerLine?.hidden = true
            }
        }
    }
    
    func editBtnTapped(sender: UIButton) {
        let btnPosition = sender.convertPoint(CGPointZero, toView: dataTableView)
        let selectedIndex = dataTableView.indexPathForRowAtPoint(btnPosition)
        
        delegate.tableViewCellEditButtonTapped(selectedIndex!)
    }
    
    func headerColumnBtnTapped(sender: UIButton) {
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
    func sortingDataTableArray(intValue: Int, boolValue: Bool) {
        let sort = NSSortDescriptor(key: "rowColumn\(intValue+1)", ascending:boolValue)
        if shouldShowSearchResults {
            filteredDataTableArray.sortUsingDescriptors([sort])
        }else {
            dataTableArray.sortUsingDescriptors([sort])
        }
        dataTableView.reloadData()
    }
    
    //MARK: - Search Bar Delegate Methods
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        shouldShowSearchResults = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        dataTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            dataTableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchText == "" {
            shouldShowSearchResults = false
        }else {
            shouldShowSearchResults = true
            //filtered with firstname and last name. Give the column names respectively to be sorted
            let results = dataTableArray.filter({ person in
                if let firstname = person["rowColumn1"] as? String, lastname = person["rowColumn2"] as? String, query = searchBar.text {
                    return firstname.rangeOfString(query, options: [.CaseInsensitiveSearch, .DiacriticInsensitiveSearch]) != nil || lastname.rangeOfString(query, options: [.CaseInsensitiveSearch, .DiacriticInsensitiveSearch]) != nil
                }
                return false
            })
            filteredDataTableArray = NSMutableArray(array: results)
        }
        dataTableView.reloadData()
    }
}
