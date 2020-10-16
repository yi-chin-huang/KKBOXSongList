//
//  TrackTableCell.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//

import KKBOXOpenAPISwift
import UIKit

class TrackTableCell: UITableViewCell {
    static let imageHeight: CGFloat = 60
    static let imageWidth = TrackTableCell.imageHeight
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter
    }()
    private let trackImageView: UIImageView = {
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
    
    override func prepareForReuse() {
        nameLabel.text = nil
        trackImageView.image = nil
    }
    
    private func installLayout() {
        contentView.addSubview(trackImageView)
        NSLayoutConstraint.activate([
            trackImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackImageView.heightAnchor.constraint(equalToConstant: TrackTableCell.imageHeight),
            trackImageView.widthAnchor.constraint(equalToConstant: TrackTableCell.imageWidth)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: trackImageView.trailingAnchor, constant: 15),
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
    
    func setContent(trackInfo: KKTrackInfo) {
        nameLabel.text = trackInfo.name
        descriptionLabel.text = "\(trackInfo.album?.artist?.name ?? "Unknown Artist")@\(trackInfo.album?.releaseDate ?? "Unknown Release Date")"
        guard let url = trackInfo.album?.images.first?.url else { return }

        trackImageView.loadImage(with: url)
    }
}
