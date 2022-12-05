//
//  PosterCollectionViewCell.swift
//  Instagram-App
//
//  Created by Joseph Estanislao Calla Moreyra on 4/12/22.
//

import SDWebImage
import UIKit

final class PosterCollectionViewCell: UICollectionViewCell {
    static let identifier = "PosterCollectionViewCell"
    
    private let imageView: UIImageView = {
      let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePadding: CGFloat = 4
        let imageSize: CGFloat = contentView.height - (imagePadding * 2)
        imageView.frame = CGRect(x: 2, y: 2, width: imageSize,
                                 height: imageSize)
        imageView.layer.cornerRadius = imageSize/2
        
        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(x: imageView.right+10, y: (contentView.height-55)/2,
                                     width: usernameLabel.width,
                                     height: usernameLabel.height)
        
        moreButton.frame = CGRect(x: contentView.width-55, y: (contentView.height-55)/2, width: 50, height: 50)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        imageView.image = nil
    }
    
    func configure(with viewModel: PosterCollectionViewCellViewModel) {
        usernameLabel.text = viewModel.username
        imageView.sd_setImage(with: viewModel.profilePictureURL)
    }
    
    @objc func didTapMore() {
        
    }
}
