//
//  HistoryTableViewCell.swift
//  StopWatchApp
//
//  Created by Alisher Zinullayev on 10.07.2023.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {

    static let identifier = String(describing: HistoryTableViewCell.self)
    
    private let lapIndex: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeForLap: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lapIndex)
        contentView.addSubview(timeForLap)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let lapIndexConstraints = [
            lapIndex.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lapIndex.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ]
        let timeForLapConstraints = [
            timeForLap.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeForLap.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(lapIndexConstraints)
        NSLayoutConstraint.activate(timeForLapConstraints)
    }
    
    public func configure(index: String, time: String) {
        lapIndex.text = index
        timeForLap.text = time
    }
}
