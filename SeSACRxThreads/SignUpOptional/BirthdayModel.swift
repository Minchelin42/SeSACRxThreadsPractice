//
//  BirthdayModel.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/03.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class BirthdayModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let birthday: ControlProperty<Date>
        let nextButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let year: Driver<String>
        let month: Driver<String>
        let day: Driver<String>
        
        let infoMessage: Driver<String>
        let validation: Driver<Bool>
        let nextButtonClicked: ControlEvent<Void>
        
    }
    
    func transform(input: Input) -> Output {
        //뭔가 코드가 줄어들어서 뿌-듯.
        let year = PublishRelay<Int>()
        let month = PublishRelay<Int>()
        let day = PublishRelay<Int>()
        let infoMessage = PublishRelay<String>()
        
        let validation = PublishRelay<Bool>()
        
        input.birthday
            .subscribe(with: self) { owner, value in
                let nowComponent = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                
                let pickerComponent = Calendar.current.dateComponents([.year, .month, .day], from: value)

                if nowComponent.year! - pickerComponent.year! >= 19 {
                    validation.accept(true)
                } else if nowComponent.year! - pickerComponent.year! == 18 {
                    if nowComponent.month! < pickerComponent.month! {
                        validation.accept(false)
                    } else if nowComponent.month! == pickerComponent.month! {
                        if nowComponent.day! < pickerComponent.day! {
                            validation.accept(false)
                        } else {
                            validation.accept(true)
                        }
                    } else {
                        validation.accept(true)
                    }
                } else {
                    validation.accept(false)
                }

                year.accept(pickerComponent.year!)
                month.accept(pickerComponent.month!)
                day.accept(pickerComponent.day!)
                
            }
            .disposed(by: disposeBag)
        
        let yearResult = year.map { "\($0)년" }.asDriver(onErrorJustReturn: "")
        let monthResult = month.map { "\($0)월" }.asDriver(onErrorJustReturn: "")
        let dayResult = day.map { "\($0)일" }.asDriver(onErrorJustReturn: "")
        
        validation
            .subscribe(with: self) { owner, value in
                if value {
                    infoMessage.accept("가입 가능한 나이입니다")
                } else {
                    infoMessage.accept("만 17세 이상만 가입 가능합니다")
                }
            }
            .disposed(by: disposeBag)
        
        let infoResult = infoMessage.asDriver(onErrorJustReturn: "")
        
        return Output(year: yearResult, month: monthResult, day: dayResult, infoMessage: infoResult, validation: validation.asDriver(onErrorJustReturn: false), nextButtonClicked: input.nextButtonClicked)
    }
    
    
    
    
    
}

