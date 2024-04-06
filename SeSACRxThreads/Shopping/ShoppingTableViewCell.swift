//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingTableViewCell: UITableViewCell {
    
    static let identifier = "ShoppingTableCell"
    
    var disposeBag = DisposeBag()
    let viewModel = ShoppingTableViewCellViewModel()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    let starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    let listLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .systemPink
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkButton.setImage(nil, for: .normal)
        starButton.setImage(nil, for: .normal)
        
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(checkButton)
        contentView.addSubview(listLabel)
        contentView.addSubview(starButton)
        
        checkButton.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(self).inset(10)
            make.width.equalTo(30)
        }
        
        listLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self).inset(10)
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
            make.trailing.equalTo(starButton.snp.leading).offset(-10)
        }
        
        starButton.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(self).inset(10)
            make.width.equalTo(30)
        }
    }
}

