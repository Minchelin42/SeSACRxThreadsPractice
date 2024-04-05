//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let validationLabel = UILabel()
    
    let viewModel = PhoneViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    private func bind() {
        
        viewModel.defaultNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        let input = PhoneViewModel.Input(nextButtonClicked: nextButton.rx.tap, phoneNumber: phoneTextField.rx.text)
        
        let output = viewModel.transform(input: input)
        
        phoneTextField.rx.text
            .subscribe(input.phoneNumber)
            .disposed(by: disposeBag)
        
        output.validation
            .drive(with: self) { owner, value in
                owner.validationLabel.isHidden = value
                owner.nextButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        output.validationText
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nextButtonClicked
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }.disposed(by: disposeBag)
        
        output.nextButtonClicked
            .subscribe(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }.disposed(by: disposeBag)
        
    }


    
    private func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(validationLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        validationLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(validationLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
