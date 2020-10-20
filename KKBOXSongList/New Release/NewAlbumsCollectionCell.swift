//
//  NewAlbumsCollectionCell.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//
import UIKit

class NewAlbumsCollectionCell: UICollectionViewCell {
    static let imageWidth: CGFloat = 60
    static let imageHeight = NewAlbumsCollectionCell.imageWidth
    static let titleHeight: CGFloat = 40
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        installLayout()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(imageUrl: URL?, title: String) {
        titleLabel.text = title
        guard let url = imageUrl else { return }

        imageView.loadImage(with: url)
    }
    
    private func installLayout() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: NewAlbumsCollectionCell.imageHeight),
            imageView.widthAnchor.constraint(equalToConstant: NewAlbumsCollectionCell.imageWidth)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
    }
}
