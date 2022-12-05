//
//  PostDateCollectionViewCell.swift
//  Instagram-App
//
//  Created by Joseph Estanislao Calla Moreyra on 4/12/22.
//

import UIKit

class PostDateCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostDateCollectionViewCell"
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondaryLabel
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with viewModel: PostDatetimeCollectionViewCellViewModel) {
        let date = viewModel.date
        label.text = .date(from: date)
    }
}

