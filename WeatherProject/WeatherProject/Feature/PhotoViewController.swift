//
//  PhotoViewController.swift
//  WeatherProject
//
//  Created by 김도형 on 2/4/25.
//

import UIKit
import PhotosUI

import SnapKit

protocol PhotoViewControllerDelegate: AnyObject {
    func collectionViewDidSelectItem(image: UIImage?)
}

final class PhotoViewController: UIViewController {
    private lazy var collectionView = {
        return configureCollectionView()
    }()
    private lazy var phpPickerController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.selection = .ordered
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }()
    
    private var images: [UIImage?] = []
    
    weak var delegate: (any PhotoViewControllerDelegate)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
    }
}

// MARK: Configure View
private extension PhotoViewController {
    func configureUI() {
        view.backgroundColor = .white
        
        configureNavigation()
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(plusButtonTouchUpInside)
        )
    }
    
    func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let global = view.frame
        let spacing = CGFloat(16)
        let width = (global.width - 40 - 2 * spacing) / 3
        
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: .photoCollectionCell
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        return collectionView
    }
}

// MARK: Functions
private extension PhotoViewController {
    @objc
    func plusButtonTouchUpInside() {
        present(phpPickerController, animated: true)
    }
}

extension PhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        Task {
            for provider in results.map(\.itemProvider) {
                let canLoadObject = provider.canLoadObject(ofClass: UIImage.self)
                guard canLoadObject else { continue }
                
                let image: UIImage? = await withCheckedContinuation { continuation in
                    provider.loadObject(ofClass: UIImage.self) { image, error in
                        continuation.resume(returning: image as? UIImage)
                    }
                }
                images.append(image)
            }
            collectionView.reloadData()
        }
        dismiss(animated: true)
    }
}

extension PhotoViewController: UICollectionViewDelegate,
                               UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .photoCollectionCell,
            for: indexPath
        ) as? PhotoCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        cell.forItemAt(images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionViewDidSelectItem(image: images[indexPath.item])
        collectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: PhotoViewController())
}
