//
//  ProfileVC.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 2.01.2023.
//

import UIKit
import SnapKit
import FirebaseStorage
import SDWebImage

final class ProfileVC: UIViewController {
    
    fileprivate let storage = Storage.storage().reference().storage
    
    // MARK: - UI Elements
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.secondaryLabel.cgColor
        imageView.layer.borderWidth = 1
        imageView.image = UIImage(named: "cover-image")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 40
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var postsCollectionView: UICollectionView = {
        let size = self.view.frame.size.width / 3 - 15
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = .init(width: size, height: size)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        storage.reference(withPath: "/profile_images/\((tabBarController as! MainTabBarController).currentUser.email.lowercased()).png").downloadURL { [weak self] url, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self?.profileImageView.sd_setImage(with: url)
            }
        }
        view.addSubview(coverImageView)
        view.addSubview(profileImageView)
        view.addSubview(postsCollectionView)
        layout()
    }
    
    fileprivate func layout() {
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(80)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(coverImageView.snp.bottom)
            make.leading.equalTo(coverImageView.snp.leading).offset(30)
            make.height.width.equalTo(80)
        }
        
        postsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - OBJC Functions
    
    
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.layer.borderColor = UIColor.secondaryLabel.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
}
