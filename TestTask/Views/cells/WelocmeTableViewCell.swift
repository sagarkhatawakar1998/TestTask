//
//  WelocmeTableViewCell.swift
//  TestTask
//
//

import UIKit
import SDWebImage

protocol WelocmeTableViewCellDelegate: AnyObject {
    func didTapcheckbox(_ indexpath: IndexPath, sender: UIButton)
}



class WelocmeTableViewCell: UITableViewCell {
    private weak var delegate: WelocmeTableViewCellDelegate?
    private var indexPath: IndexPath?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        profileImage.layer.cornerRadius = 8
        profileImage.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    // update cell info with the indexpath and delgate
    func updateCellInfo(_ indexpath: IndexPath, delegate: WelocmeTableViewCellDelegate) {
        self.delegate = delegate
        self.indexPath = indexpath
    }
    
    
    // configure the data with views
    func configureModel(with model: WelcomeModel, isSelcted: Bool) {
        self.profileImage.sd_setImage(with: URL(string: model.download_url))
        self.titleLabel.text = model.id
        self.descriptionLabel.text = model.author
        
        if isSelcted {
            self.checkboxButton.setImage(UIImage(named: "circleRightBlack"), for: .normal)
        }
        else {
            self.checkboxButton.setImage(UIImage(named: "circleOutline"), for: .normal)
        }
        
    }
    
    
    @IBAction func didTapCheckBox(_ sender: UIButton) {
        guard let indexPath = self.indexPath else {
            return
        }
        delegate?.didTapcheckbox(indexPath, sender: sender)
    }
}
