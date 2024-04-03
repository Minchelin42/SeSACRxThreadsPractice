//
//  ShoppingEditViewController.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingEditViewController: UIViewController {

    let editTextField = SignTextField(placeholderText: "수정할 입력해주세요")
    let validationButton = UIButton()
    let editButton = PointButton(title: "수정")
    let deleteButton = PointButton(title: "삭제")
    
    var isEdit: Bool? = nil // true: edit, false: delete
    var listTitle = ""
    
    let disposeBag = DisposeBag()
    
    let viewModel = ShoppingEditViewModel()
    
    var editOrDelete: ((Bool?, String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        bind()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        editOrDelete?(isEdit, listTitle)
    }
    
    deinit {
        print("deinit")
    }

    func bind() {
        
        editTextField.rx.text.orEmpty
            .bind(to: viewModel.inputEdit)
            .disposed(by: disposeBag)
        
        viewModel.inputEdit
            .subscribe(with: self) { owner, value in
                owner.listTitle = value
            }
            .disposed(by: disposeBag)
        
//        editTextField.rx.text.orEmpty
//            .subscribe(with: self) { owner, value in
//                owner.listTitle = value
//            }
//            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .bind(to: viewModel.editButtonClicked)
            .disposed(by: disposeBag)
        
        viewModel.editButtonClicked
            .withLatestFrom(editTextField.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                owner.isEdit = true
                owner.listTitle = value
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(to: viewModel.deleteButtonClicked)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.isEdit = false
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        editButton.backgroundColor = .systemBlue
        deleteButton.backgroundColor = .systemRed
        editTextField.text = listTitle
    }
    
    private func configureLayout() {
        view.addSubview(editTextField)
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
        editTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        editButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(editTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(editButton.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
