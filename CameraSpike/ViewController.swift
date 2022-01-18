//
//  ViewController.swift
//  CameraSpike
//
//  Created by Zachary Buffington on 11/29/21.
//

import UIKit
import Photos
import PhotosUI
class MyCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
}


class ViewController: UIViewController, PHPickerViewControllerDelegate, UICollectionViewDataSource {
    
    private var images: [UIImage] = []
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.frame = view.bounds
        title = "New Photo Picker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCell else {
            fatalError()
        }
        cell.imageView.image = images[indexPath.item]
        return cell
        
    }
    @objc private func didTapAdd() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
        
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        self.images = []
            results.forEach { result in
                result.itemProvider.loadObject(ofClass: UIImage.self) { item, _ in
                    DispatchQueue.main.async {
                    if let item = item as? UIImage {
                        self.images.append(item)   
                    }
                }
                
                
            }
            self.collectionView.reloadData()
        }
    }
}



