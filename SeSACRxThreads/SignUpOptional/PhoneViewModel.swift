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
    
    let defaultNumber = BehaviorSubject(value: "010")
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonClicked: ControlEvent<Void>
        let phoneNumber: ControlProperty<String?>
    }
    
    struct Output {
        
        let nextButtonClicked: ControlEvent<Void>
        
        let validation: Driver<Bool>
        let validationText: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let validation = PublishRelay<Bool>()
        let validationText = PublishRelay<String>()
        
        input.phoneNumber.orEmpty
            .subscribe(with: self) { owner, value in
                guard Int(value) != nil else {
                    validation.accept(false)
                    validationText.accept("입력형식이 올바르지않습니다")
                    return
                }
                
                if value.count < 10 {
                    validationText.accept("휴대폰번호는 10자이상으로 입력해주세요")
                    validation.accept(false)
                } else {
                    validation.accept(true)
                }
            }
            .disposed(by: disposeBag)
   
        
        return Output(nextButtonClicked: input.nextButtonClicked, validation: validation.asDriver(onErrorJustReturn: false), validationText: validationText.asDriver(onErrorJustReturn: ""))
    }
    
    
}
