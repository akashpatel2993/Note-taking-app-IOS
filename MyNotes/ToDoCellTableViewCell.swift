//
//  ToDoCellTableViewCell.swift
//  MyNotes
//
//  Created by jay on 2016-11-21.
//  Copyright © 2016 jay. All rights reserved.
//

import UIKit
typealias ToDoCellDidTapButtonHandler = () -> ()

class ToDoCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    var didTapButtonHandler: ToDoCellDidTapButtonHandler?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: -
    // MARK: View Methods
    private func setupView() {
        let imageNormal = UIImage(named: "doneNormal")
        let imageSelected = UIImage(named: "doneSelected")
        
        btnDone.setImage(imageNormal, for: .normal)
        btnDone.setImage(imageNormal, for: .disabled)
        btnDone.setImage(imageSelected, for: .selected)
        btnDone.setImage(imageSelected, for: .highlighted)
        btnDone.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
    }
    
    // MARK: -
    // MARK: Actions
    func didTapButton(sender: AnyObject) {
        if let handler = didTapButtonHandler {
            handler()
        }
    }

}
