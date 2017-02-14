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
        
        dataTableView = Bundle.main.loadNibNamed("PBDataTableView", owner: self, options: nil)?.first as! PBDataTableView
        dataTableView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height-20)
        dataTableView.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        dataTableView.delegate = self
        dataTableView.enableSorting = true

        //Search bar can be customized, now it was set to default value. Search is enabled with first 2 columns.
        dataTableView.enableSearchBar = true

        //Header name and width size can be dynamic. Table view will be re-sized respectively, if total width exceeds the Super view Width table view will be scrolled.
        dataTableView.columnDataArray = [["name":"FirstName","widthSize":110],["name":"LastName","widthSize":110],["name":"Address","widthSize":180],["name":"City","widthSize":110],["name":"Zip","widthSize":100],["name":"PhoneNumber","widthSize":158]]
        
        //Not to change the Key of the Dictionaries if needs to be dynamic.
        dataTableView.dataTableArray = dataTableViewdictParams()
        
        //Only if you want the Last column to be button make use of below two lines of code. You can cutomize the Button from PBDataTableViewCell.
        ApplicationDelegate.cellLastColumnButtonEnable = true
        dataTableView.lastColumnButtonHeaderName = "Edit"

        dataTableView.setupView()
        self.view.addSubview(dataTableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        //T0 change the Constraints and make the view scrollable make sure you add this line in View Did Appear.
        dataTableView.configureView()
    }
    
    func tableViewDidSelectedRow(_ indexPath: IndexPath) {
        print("selected row: \(indexPath)")
    }
    
    func tableViewCellEditButtonTapped(_ indexPath: IndexPath) {
        print("selected row: \(indexPath)")
    }
    
    func changeStatusBarColor() {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1)
    }
    
    func dataTableViewdictParams() -> NSMutableArray {
        let dataTableArray = [
                                ["rowColumn1":"Ajay","rowColumn2":"Zener","rowColumn3":"23, Settembre","rowColumn4":"Rome","rowColumn5":NSNumber(value: 80099 as Int),"rowColumn6":NumberFormatter().number(from: "6766665")!],
                          
                                ["rowColumn1":"Peter","rowColumn2":"Hayes","rowColumn3":"Richmond Street","rowColumn4":"Hoboken","rowColumn5":NSNumber(value: 50043 as Int),"rowColumn6":NumberFormatter().number(from: "8676766665")!],
                          
                                ["rowColumn1":"Aaron","rowColumn2":"Joe","rowColumn3":"Goodman Susan E, 42 Grove St","rowColumn4":"NewYork","rowColumn5":NSNumber(value: 10014 as Int),"rowColumn6":NumberFormatter().number(from: "9889499449")!],
            
                                ["rowColumn1":"Gabriel","rowColumn2":"Ella","rowColumn3":"9 Barrow Owners Corporation","rowColumn4":"NewYork","rowColumn5":NSNumber(value: 10033 as Int),"rowColumn6":NumberFormatter().number(from: "5676667667")!],
                                ["rowColumn1":"Matthew","rowColumn2":"William","rowColumn3":"401-505 LaGuardia Pl","rowColumn4":"NewYork","rowColumn5":NSNumber(value: 10011 as Int),"rowColumn6":NumberFormatter().number(from: "8099078771")!],
                                ["rowColumn1":"Scarlett","rowColumn2":"","rowColumn3":"301 Garden St Hoboken","rowColumn4":"Hoboken","rowColumn5":NSNumber(value: 10022 as Int),"rowColumn6":NumberFormatter().number(from: "4323445555")!],
                                ["rowColumn1":"Hannah","rowColumn2":"Andrew","rowColumn3":"Sixteenth St Jersey City","rowColumn4":"New Jersey","rowColumn5":NSNumber(value: 13222 as Int),"rowColumn6":NumberFormatter().number(from: "7666676555")!],
                                ["rowColumn1":"Alexa","rowColumn2":"Joe","rowColumn3":"211 County Ave Secaucus","rowColumn4":"New Jersey","rowColumn5":NSNumber(value: 12022 as Int),"rowColumn6":NumberFormatter().number(from: "9889888888")!],
                                ["rowColumn1":"Hunter","rowColumn2":"Ryan","rowColumn3":"Edgmont Township","rowColumn4":"Philadelphia","rowColumn5":NSNumber(value: 11001 as Int),"rowColumn6":NumberFormatter().number(from: "6567766776")!],
                                ["rowColumn1":"Lucy","rowColumn2":"Adrian","rowColumn3":"Secaucus, NJ","rowColumn4":"New Jersey","rowColumn5":NSNumber(value: 10003 as Int),"rowColumn6":NumberFormatter().number(from: "7455455551")!]] as NSMutableArray
        
        return dataTableArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

