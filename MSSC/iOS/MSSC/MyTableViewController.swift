//
//  MyTableViewCell.swift
//  MSSC
//
//  Created by 王一道 on 2016/02/06.
//  Copyright © 2016年 王一道. All rights reserved.
//

import Foundation
import UIKit

class MyTableViewController:UITableViewController{
    
    private func getTableView()->UITableView{
      return view as! UITableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        for section in 0..<getTableView().numberOfSections {
            
            for row in 0..<getTableView().numberOfRowsInSection(section) {
                
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! PropatyTableViewCell
                if(cell.value?.text == ""){
                    DoneButton?.enabled = false
                    return
                }
            }
        }
        DoneButton?.enabled = true
    }
    private var subVC: InputTextViewController?
    
    @IBOutlet var DoneButton: UIBarButtonItem?
    @IBOutlet var CancelButton: UIBarButtonItem?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toInputTextViewController",sender: nil)
        subVC?.setPropaty(tableView, indexPath: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toInputTextViewController") {
            subVC = (segue.destinationViewController as? InputTextViewController)!
        }
    }
}
