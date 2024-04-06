//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct Wish {
    var check: Bool
    var title: String
    var star: Bool
    
    init(title: String) {
        self.check = false
        self.title = title
        self.star = false
    }
}

class ShoppingViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let textField = UITextField()
    let searchBar = UISearchBar()
    let inputButton = {
       let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let viewModel = ShoppingViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureUI()
        bind()
    }
    
    private func configureUI() {
        
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        view.addSubview(tableView)
        view.addSubview(textField)
        view.addSubview(inputButton)
        
        textField.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(inputButton.snp.leading)
            make.height.equalTo(30)
        }
        
        inputButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        textField.backgroundColor = .cyan
        textField.placeholder = "새로운 항목을 입력하세요"
    }
    
    private func bind() {
        
        let input = ShoppingViewModel.Input(inputSearch: searchBar.rx.text, inputShopping: textField.rx.text, searchButtonClicked: searchBar.rx.searchButtonClicked, inputButtonClicked: inputButton.rx.tap)
        
        let output = viewModel.transform(input: input)

        output.items.bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in
            
            cell.listLabel.text = "\(element.title)"
            cell.starButton.setImage(UIImage(systemName: element.star ? "star.fill" : "star"), for: .normal)
            cell.checkButton.setImage(UIImage(systemName: element.check ? "checkmark.square.fill" : "checkmark.square"), for: .normal)
            
            let cellInput = ShoppingTableViewCellViewModel.Input(starButtonClicked: cell.starButton.rx.tap, checkButtonClicked: cell.checkButton.rx.tap)
            
            let cellOutput = cell.viewModel.transform(input: cellInput)
            
            cell.starButton.rx.tap
                .map { return row }
                .subscribe(with: self) { owner, value in
                    cell.viewModel.list = owner.viewModel.list
                    cell.viewModel.nowList = owner.viewModel.nowList
                    cell.viewModel.nowIndex = value
                }
                .disposed(by: cell.disposeBag)
            
            cell.checkButton.rx.tap
                .map { return row }
                .subscribe(with: self) { owner, value in
                    cell.viewModel.list = owner.viewModel.list
                    cell.viewModel.nowList = owner.viewModel.nowList
                    cell.viewModel.nowIndex = value
                }
                .disposed(by: cell.disposeBag)
            
            cellOutput.items.subscribe(with: self) { owner, value in
                owner.viewModel.nowList = cell.viewModel.nowList
                owner.viewModel.list = cell.viewModel.list
                output.items.onNext(value)
            }
            .disposed(by: cell.disposeBag)
   
        }
        .disposed(by: disposeBag)
        
       


/*
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Wish.self))
            .bind(with: self) { owner, value in
                print(value.0.row, value.1.title) //indexPath.row, wish.title
                let vc = ShoppingEditViewController()
                vc.listTitle = value.1.title
                vc.editOrDelete = { isEdit, newTitle in
                    guard let isEdit = isEdit else { return }
                    if isEdit {
                        owner.viewModel.list[value.0.row].title = newTitle
                    } else {
                        owner.viewModel.list.remove(at: value.0.row)
                    }
                    owner.viewModel.items.onNext(owner.viewModel.list)
                }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)*/
        
    }

}
