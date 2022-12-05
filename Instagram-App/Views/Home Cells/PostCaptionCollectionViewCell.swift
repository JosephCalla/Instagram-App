//
//  PostCaptionCollectionViewCell.swift
//  Instagram-App
//
//  Created by Joseph Estanislao Calla Moreyra on 4/12/22.
//

import UIKit

class PostCaptionCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCaptionCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: PostCaptionCollectionViewCellViewModel) {
        
    }
}
