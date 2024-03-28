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

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    var phoneNum = Observable.just("010")
    let validationLabel = UILabel()
    var validationText = BehaviorSubject(value: "휴대폰번호를 입력해주세요")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        phoneNum.bind(to: phoneTextField.rx.text).disposed(by: disposeBag)
        
        validationText.bind(to: validationLabel.rx.text).disposed(by: disposeBag)
        
        let validation = phoneTextField.rx.text.orEmpty
        
        validation.bind(with: self) { owner, value in
            guard let number = Int(value) else {
                owner.validationText.onNext("입력형식이 올바르지않습니다")
                owner.validationLabel.isHidden = false
                owner.nextButton.isEnabled = false
                return
            }
            
            if value.count < 10 {
                owner.validationText.onNext("휴대폰번호는 10자이상으로 입력해주세요")
                owner.validationLabel.isHidden = false
                owner.nextButton.isEnabled = false
            } else {
                owner.validationLabel.isHidden = true
                owner.nextButton.isEnabled = true
            }
            
        }
        .disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
        }.disposed(by: disposeBag)
        
    }


    
    func configureLayout() {
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
