//
//  ViewController.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 18.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import UIKit

protocol ChosenImageDelegate: class {
    func sendChosenPhoto(_ imageURL: String, _ downloadingData: String)
}

class InfinityScrollController: UICollectionViewController {
    
    private var getMoreImages = false
    private var flickrImagesEntitys = [FlickrPhotoRealm]()
    private let viewModel = InfinityScrollViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupCollectionView()

        loadMoreFlickrImages()
    }

    private func setupNavBar(){
        navigationItem.title = "Renta Test"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
    }

    private func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView?.backgroundColor = .white
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
    }

}

// MARK: Collection View Data Source
extension InfinityScrollController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrImagesEntitys.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCell {

            let image = flickrImagesEntitys[indexPath.row]
            cell.imageInfoLabel.text = image.title
            cell.imageURL = image.urlQ

            return cell
        } else {
            let emptycell = UICollectionViewCell()
            return emptycell
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height - 400 {
            if !getMoreImages {
                loadMoreFlickrImages()
            }
        }
    }

    private func loadMoreFlickrImages(){
        getMoreImages = true
        viewModel.getRandomImages { [weak self] (images) in
            if let images = images {
                self?.flickrImagesEntitys.append(contentsOf: images)
                self?.getMoreImages = false
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageEntity = flickrImagesEntitys[indexPath.row]
        if let imageURL = imageEntity.urlZ {
            let newVC = ChosenImageController()
            newVC.modalPresentationStyle = .fullScreen
            newVC.sendChosenPhoto(imageURL, imageEntity.loadedDate)
            self.present(newVC, animated: true, completion: nil)
        } else {
            return
        }
    }
}

// MARK: Collection View Flow Layout
extension InfinityScrollController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
