# PBDataTableView
DataTable for iPhone and iPad

An easy-to-use PBDataTableView with sorting and search option.

Quick Start:
1. Drop PBDataTableView.swift and PBDataTableViewCell.swift with their respective xib files.
2. Intialize the xib file on your view controller.
3. Set up the PBDataTableView with frame and customize the search bar.
4. The Header of the Tableview given to "columnDataArray" with name of the header and the width size of the each header. (If total width of the header exceeds its superview the view will be scrolled horizontally.)
5. The Row content of the Tableview given to "dataTableArray" as shown in ViewController.
NOTE* It will be easy if you dont change the dictionay key. If you need to change the Keys, please make the change on "PBDataTableView" too.