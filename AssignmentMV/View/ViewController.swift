//
//  ViewController.swift
//  AssignmentMV
//
//  Created by Himanshu Saraswat on 20/08/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Constants {
        static let cellIdentifier = "VMFeedTableViewCell"
        static let cancel = "Cancel"
        static let blank = ""
        static let kURL = "http://pastebin.com/raw/wgkJgazE"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerVMCell()
        self.addrefreshControl()
        self.loadVMDetails()
    }
    
    //MARK:- Properties
    @IBOutlet weak var vmTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var vmInformation: [VM_Base]?
    
    //refresh Table logic
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    // drag table to refresh contact
    func addrefreshControl() {
        self.vmTableView.addSubview(self.refreshControl)
    }
    
    private func loadVMDetails(pullToRefresh: Bool = false) {
        if !pullToRefresh {
            startLoadingIndicator()
        }
        // get Data from service
        let vModel = VMFeedViewModel(vmInfo: nil, vmDelegate: self, endPoint: Constants.kURL)
        vModel.fetchDetails()
    }
    
    func startLoadingIndicator() {
        // start activity spinner
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        loadVMDetails(pullToRefresh: true)
    }
    
    func updateTableView() {
        self.refreshControl.endRefreshing()
        self.activityIndicator.stopAnimating()
        self.vmTableView.isHidden = false
        self.vmTableView.reloadData()
    }
    
    func registerVMCell() {
        self.vmTableView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
}

// MARK: Handel data from service
extension ViewController: VMInformation {
    func updateNewsDetails(vmDetails: Any?, error: Error?) {
        
        if error == nil {
            guard let response = vmDetails as? [VM_Base] else {
                    return
            }
            
            self.vmInformation = response
            DispatchQueue.main.async{
                self.updateTableView()
            }
        } else if let erorrDiscription = error {
            DispatchQueue.main.async {
                self.updateTableView()
                let alertViewController = UIAlertController(title: Constants.blank, message: erorrDiscription.localizedDescription, preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: Constants.cancel, style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
}

