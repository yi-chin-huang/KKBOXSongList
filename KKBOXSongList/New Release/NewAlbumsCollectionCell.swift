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
    private let imageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    private var indexPath: IndexPath?
    private var onReuse: (() -> Void)?
    weak var delegate: NewAlbumsCollectionCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        installConstraints()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageView.image = nil
        indexPath = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(imageUrl: URL?, title: String, indexPath: IndexPath) {
        titleLabel.text = title
        self.indexPath = indexPath
        guard let url = imageUrl else { return }

        imageView.loadImage(with: url)
    }
    
    private func installConstraints() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: NewAlbumsCollectionCell.imageHeight),
            imageView.widthAnchor.constraint(equalToConstant: NewAlbumsCollectionCell.imageWidth)
        ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
    }
}

protocol NewAlbumsCollectionCellDelegate: AnyObject {
    func reload(indexPath: IndexPath)
}
