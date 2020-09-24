//
//  ChosenImageController.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 18.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import UIKit

class ChosenImageController: UIViewController, ChosenImageDelegate {

    private let closeButton = UIButton(type: .close)
    private let imageInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Thonburi", size: 20.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var image = UIImage()
    private var imageScrollView: ImageScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        setupInfoLabel()
        setupCloseButton()

        self.imageScrollView.set(image: image)
    }
    private func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

    private func setupInfoLabel(){
        view.addSubview(imageInfoLabel)
        imageInfoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        imageInfoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }

    private func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width

        view.addSubview(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
    }

    func sendChosenPhoto(_ chosenImage: UIImage, _ downloadingData: String) {
        self.image = chosenImage
        self.imageInfoLabel.text = downloadingData
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

}
