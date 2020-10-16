//
//  PlaylistsTableCell.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//

import UIKit

class PlaylistsTableCell: UITableViewCell {
    static let imageHeight: CGFloat = 60
    static let imageWidth = PlaylistsTableCell.imageHeight
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter
    }()
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .clear
        selectionStyle = .none
        installLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func installLayout() {
        contentView.addSubview(playlistImageView)
        NSLayoutConstraint.activate([
            playlistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playlistImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playlistImageView.heightAnchor.constraint(equalToConstant: PlaylistsTableCell.imageHeight),
            playlistImageView.widthAnchor.constraint(equalToConstant: PlaylistsTableCell.imageWidth)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: playlistImageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setContent(imageUrl: URL?, title: String, owner: String, lastUpdateDate: Date) {
        nameLabel.text = title
        descriptionLabel.text = "\(owner)@\(dateFormatter.string(from: lastUpdateDate))"
        guard let url = imageUrl else { return }

        playlistImageView.loadImage(with: url)
    }
}
