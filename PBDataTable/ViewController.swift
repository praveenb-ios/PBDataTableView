//
//  ViewController.swift
//  PBDataTable
//
//  Created by praveen b on 6/10/16.
//  Copyright © 2016 Praveen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PBDataTableViewDelegate {
    var dataTableView: PBDataTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        changeStatusBarColor()
        
        dataTableView = NSBundle.mainBundle().loadNibNamed("PBDataTableView", owner: self, options: nil).first as! PBDataTableView
        dataTableView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-20)
        dataTableView.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        dataTableView.delegate = self
        dataTableView.enableSorting = true

        //Search bar can be customized, now it was set to default value. Search is enabled with first 2 columns.
        dataTableView.enableSearchBar = true

        //Header name and width size can be dynamic. Table view will be re-sized respectively, if total width exceeds the Super view Width table view will be scrolled.
        dataTableView.columnDataArray = [["name":"FirstName","widthSize":110],["name":"LastName","widthSize":110],["name":"Address","widthSize":180],["name":"City","widthSize":110],["name":"Zip","widthSize":100],["name":"PhoneNumber","widthSize":158]]
        
        //Not to change the Key of the Dictionaries if needs to be dynamic.
        dataTableView.dataTableArray = dataTableViewdictParams()
        
        ApplicationDelegate.cellLastColumnButtonEnable = true
        dataTableView.lastColumnButtonHeaderName = "Edit"

        dataTableView.setupView()
        self.view.addSubview(dataTableView)
    }

    override func viewDidAppear(animated: Bool) {
        //T0 change the Constraints and make the view scrollable make sure you add this line in View Did Appear.
        dataTableView.configureView()
    }
    
    func tableViewDidSelectedRow(indexPath: NSIndexPath) {
        print("selected row: \(indexPath)")
    }
    
    func tableViewCellEditButtonTapped(indexPath: NSIndexPath) {
        print("selected row: \(indexPath)")
    }
    
    func changeStatusBarColor() {
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        statusBar.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
    }
    
    func dataTableViewdictParams() -> NSMutableArray {
        let dataTableArray = [
                                ["rowColumn1":"Ajay","rowColumn2":"Zener","rowColumn3":"23, Settembre","rowColumn4":"Rome","rowColumn5":NSNumber(integer:80099),"rowColumn6":NSNumberFormatter().numberFromString("6766665")!],
                          
                                ["rowColumn1":"Peter","rowColumn2":"Hayes","rowColumn3":"Richmond Street","rowColumn4":"Hoboken","rowColumn5":NSNumber(integer:50043),"rowColumn6":NSNumberFormatter().numberFromString("8676766665")!],
                          
                                ["rowColumn1":"Aaron","rowColumn2":"Joe","rowColumn3":"Goodman Susan E, 42 Grove St","rowColumn4":"NewYork","rowColumn5":NSNumber(integer:10014),"rowColumn6":NSNumberFormatter().numberFromString("9889499449")!],
            
                                ["rowColumn1":"Gabriel","rowColumn2":"Ella","rowColumn3":"9 Barrow Owners Corporation","rowColumn4":"NewYork","rowColumn5":NSNumber(integer:10033),"rowColumn6":NSNumberFormatter().numberFromString("5676667667")!],
                                ["rowColumn1":"Matthew","rowColumn2":"William","rowColumn3":"401-505 LaGuardia Pl","rowColumn4":"NewYork","rowColumn5":NSNumber(integer:10011),"rowColumn6":NSNumberFormatter().numberFromString("8099078771")!],
                                ["rowColumn1":"Scarlett","rowColumn2":"","rowColumn3":"301 Garden St Hoboken","rowColumn4":"Hoboken","rowColumn5":NSNumber(integer:10022),"rowColumn6":NSNumberFormatter().numberFromString("4323445555")!],
                                ["rowColumn1":"Hannah","rowColumn2":"Andrew","rowColumn3":"Sixteenth St Jersey City","rowColumn4":"New Jersey","rowColumn5":NSNumber(integer:13222),"rowColumn6":NSNumberFormatter().numberFromString("7666676555")!],
                                ["rowColumn1":"Alexa","rowColumn2":"Joe","rowColumn3":"211 County Ave Secaucus","rowColumn4":"New Jersey","rowColumn5":NSNumber(integer:12022),"rowColumn6":NSNumberFormatter().numberFromString("9889888888")!],
                                ["rowColumn1":"Hunter","rowColumn2":"Ryan","rowColumn3":"Edgmont Township","rowColumn4":"Philadelphia","rowColumn5":NSNumber(integer:11001),"rowColumn6":NSNumberFormatter().numberFromString("6567766776")!],
                                ["rowColumn1":"Lucy","rowColumn2":"Adrian","rowColumn3":"Secaucus, NJ","rowColumn4":"New Jersey","rowColumn5":NSNumber(integer:10003),"rowColumn6":NSNumberFormatter().numberFromString("7455455551")!]] as NSMutableArray
        
        return dataTableArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

