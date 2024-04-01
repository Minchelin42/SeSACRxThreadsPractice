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
    
    init(check: Bool, title: String, star: Bool) {
        self.check = check
        self.title = title
        self.star = star
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
    
    var list: [Wish] = [Wish(check: true, title: "트랙패드", star: false)]
    
    let disposeBag = DisposeBag()
    
    lazy var items = BehaviorSubject(value: list)

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
    
    func bind() {
        items.bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in

            cell.listLabel.text = "\(element.title)"
            cell.starButton.setImage(UIImage(systemName: element.star ? "star.fill" : "star"), for: .normal)
            cell.checkButton.setImage(UIImage(systemName: element.check ? "checkmark.square.fill" : "checkmark.square"), for: .normal)
            
            cell.starButton.rx.tap
                .bind(with: self) { owner, _ in
                    print("starButton toggle")
                    owner.list[row].star.toggle()
                    owner.items.onNext(owner.list)
                }
                .disposed(by: cell.disposeBag)
            
            cell.checkButton.rx.tap
                .bind(with: self) { owner, _ in
                    print("starButton toggle")
                    owner.list[row].check.toggle()
                    owner.items.onNext(owner.list)
                }
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        inputButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("추가 버튼 클릭: \(value)")
                owner.list.append(Wish(title: value))
                owner.items.onNext(owner.list)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("실시간 검색: \(value)")
                let result = value.isEmpty ? owner.list : owner.list.filter{ $0.title.contains(value)}
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("검색 버튼 클릭: \(value)")
                let result = value.isEmpty ? owner.list : owner.list.filter{ $0.title.contains(value)}
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Wish.self))
            .bind(with: self) { owner, value in
                print(value.0.row, value.1.title) //indexPath.row, wish.title
                let vc = ShoppingEditViewController()
                vc.listTitle = value.1.title
                vc.editOrDelete = { isEdit, newTitle in
                    guard let isEdit = isEdit else { return }
                    if isEdit {
                        owner.list[value.0.row].title = newTitle
                    } else {
                        owner.list.remove(at: value.0.row)
                    }
                    owner.items.onNext(owner.list)
                }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        
    }

}
