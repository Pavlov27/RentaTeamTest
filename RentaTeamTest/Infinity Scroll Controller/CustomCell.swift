//
//  CustomCell.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 18.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import UIKit
import Kingfisher

class CustomCell: UICollectionViewCell {

    let imageInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Thonburi", size: 15.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let cellImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    var imageURL: String? {
        didSet {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                cellImageView.kf.setImage(with: url)
            } else {
                cellImageView.image = nil
                cellImageView.kf.cancelDownloadTask()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupImageView()
        setupImageLabel()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellImageView.image = UIImage()
        self.imageInfoLabel.text = ""
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView(){
        contentView.addSubview(cellImageView)
        cellImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    private func setupImageLabel() {
        cellImageView.addSubview(imageInfoLabel)
        imageInfoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

}
