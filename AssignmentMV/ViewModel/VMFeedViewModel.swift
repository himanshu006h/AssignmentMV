//
//  VMFeedViewModel.swift
//  AssignmentMV
//
//  Created by Himanshu Saraswat on 23/08/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import Foundation


protocol VMInformation: class {
    func updateNewsDetails(vmDetails: Any?, error: Error?)
}

struct VMFeedViewModel {
    //MARK:- Properties
    var vmInfo : VM_Base?
    weak var vmDelegate: VMInformation?
    let endPoint: String?
    
    func fetchDetails() {
    
        // Fetch data from the API
        SwiftyApiManager().connectApi(withEndPoint: endPoint, decode: [VM_Base].self, completion: { result in
            switch result {
            case let .success(feedInfo):
                self.vmDelegate?.updateNewsDetails(vmDetails: feedInfo, error: nil)
                DispatchQueue.main.async {
                    
                }
                // We had handle the error more precisely rather then just printing to console.
            // The specific type of error can generate specific error for the user
            case let .failure(error) :
                self.vmDelegate?.updateNewsDetails(vmDetails: nil, error: error)
            }
        })
    }
}
