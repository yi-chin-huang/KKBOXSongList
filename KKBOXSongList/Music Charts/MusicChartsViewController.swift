//
//  MusicChartsViewController.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//

import UIKit
import RxCocoa
import RxSwift

class MusicChartsViewController: UIViewController {
    private let viewModel = MusicChartsViewModel()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = PlaylistTableCell.imageHeight + 20
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: PlaylistTableCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        installLayout()
        setUpBindings()
    }
    
    private func setUpBindings() {
        viewModel.tableViewShouldReload
            .emit { [weak self] _ in
                self?.tableView.reloadData()
            }.disposed(by: disposedBag)

    }
    
    private func installLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15)
        ])
    }
}


extension MusicChartsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableCell.reuseIdentifier, for: indexPath) as? PlaylistTableCell else {
            return UITableViewCell()
        }
        cell.setContent(playlistInfo: viewModel.playlists[indexPath.row])
        return cell
    }
}
