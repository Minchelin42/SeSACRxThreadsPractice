//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {

    let textField = UITextField()
    
    let plusButton = UIButton()
    
    let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    var list = BehaviorSubject(value: ["Den", "Jack", "Hue", "Bran"])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        configureView()
        
        list
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                var nowList = try? owner.list.value()
                nowList?.remove(at: indexPath.row)
                owner.list.onNext(nowList ?? [])
            }
            .disposed(by: disposeBag)
        
        plusButton.rx.tap.bind(with: self) { owner, _ in
            var nowList = try? owner.list.value()
            nowList?.append(owner.textField.text ?? "")
            owner.list.onNext(nowList ?? [])
            owner.textField.text = ""
        }
        .disposed(by: disposeBag)

    }
    
    func configureView() {
        view.addSubview(textField)
        view.addSubview(plusButton)
        view.addSubview(tableView)
        
        tableView.backgroundColor = .systemCyan
        textField.backgroundColor = .systemPink
        plusButton.setTitle("저장", for: .normal)
        plusButton.backgroundColor = .darkGray
    
        textField.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
            make.trailing.equalTo(plusButton.snp.leading)
        }

        plusButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
