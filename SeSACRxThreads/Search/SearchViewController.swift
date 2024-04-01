//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let plusButton: UIButton = {
       let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()
    
    let searchBar = UISearchBar()
      
    var list = ["카카오톡", "페트와노트", "페이스북", "인스타그램"]

    lazy var items = BehaviorSubject(value: list)
     
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
    
    func bind() {
        items.bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
            
            cell.appNameLabel.text = "\(element)"
            cell.appIconImageView.backgroundColor = .systemBlue
            
            cell.downloadButton.rx.tap
                .bind(with: self) { owner, _ in
                    owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
                }
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind(with: self) { owner, value in
                print(value.0, value.1)
                
                owner.list.remove(at: value.0.row)
                owner.items.onNext(owner.list)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("실시간 검색: \(value)")
                let result = value.isEmpty ? owner.list : owner.list.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("검색 버튼 클릭: \(value)")
                let result = value.isEmpty ? owner.list : owner.list.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        plusButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let sample = ["테스트1", "테스트2", "테스트3", "테스트4", "테스트5"]
                owner.list.append(sample.randomElement()!)
                owner.items.onNext(owner.list)
            }
        
        

    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
    }

    private func configure() {
        view.addSubview(plusButton)
        view.addSubview(tableView)
        
        plusButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(plusButton.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

    }
}

