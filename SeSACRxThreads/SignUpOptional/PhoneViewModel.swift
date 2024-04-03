//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/04.
//

import Foundation
import RxSwift
import RxCocoa


final class PhoneViewModel {
    
    let validation = BehaviorRelay(value: false)
    let validationText = BehaviorRelay(value: "휴대폰번호를 입력해주세요")
    
    let defaultNumber = BehaviorSubject(value: "010")
    let inputNumber = PublishSubject<String>()
    
    let nextButtonClicked = PublishRelay<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {
        inputNumber
            .subscribe(with: self) { owner, value in
                owner.validationInput(value)
            }
            .disposed(by: disposeBag)
    }
    
    private func validationInput(_ value: String) {
        guard Int(value) != nil else {
            self.validation.accept(false)
            self.validationText.accept("입력형식이 올바르지않습니다")
            return
        }
        
        if value.count < 10 {
            self.validationText.accept("휴대폰번호는 10자이상으로 입력해주세요")
            self.validation.accept(false)
        } else {
            self.validation.accept(true)
        }
    }
    
}
