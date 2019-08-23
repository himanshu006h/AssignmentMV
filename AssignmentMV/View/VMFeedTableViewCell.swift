//
//  VMFeedTableViewCell.swift
//  AssignmentMV
//
//  Created by Himanshu Saraswat on 23/08/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import UIKit

class VMFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(vmDetail: VM_Base) {
        guard let imageURL = vmDetail.user?.profile_image?.large,
         let userName = vmDetail.user?.username,
         let profileName = vmDetail.user?.name else { return }
        
        SwiftyApiManager().download(formUrl: imageURL, completion: { result in
            switch result {
            case let .success(imageData):
                DispatchQueue.main.async {
                    self.imageViewProfile.image = UIImage(data: imageData)
                    self.layoutSubviews()
                    self.layoutIfNeeded()
                }
                // We had handle the error more precisely rather then just printing to console.
            // The specific type of error can generate specific error for the user
            case .failure(_) :
                print("Fail")
            }
        })
        
        self.lblName.text = profileName
        self.lblUserName.text = userName
    }
    
}
