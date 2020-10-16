//
//  PlaylistCoverCell.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/17.
//

import UIKit

class PlaylistCoverCell: UITableViewCell {
    static let height: CGFloat = 120
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .clear
        selectionStyle = .none
        installLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()

        coverImageView.image = nil
    }
    
    func setImage(url: URL) {
        coverImageView.loadImage(with: url)
    }

    private func installLayout() {
        contentView.addSubview(coverImageView)
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: PlaylistCoverCell.height)
        ])
    }
}
