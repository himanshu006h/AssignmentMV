//
//  ViewController+TableView.swift
//  AssignmentMV
//
//  Created by Himanshu Saraswat on 23/08/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vmInformation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? VMFeedTableViewCell,
            let details = self.vmInformation else {
                return UITableViewCell()
        }
        
        cell.configure(vmDetail: details[indexPath.row])
        return cell
    }
    
    
}
