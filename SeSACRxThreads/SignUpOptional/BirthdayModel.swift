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

class BirthdayModel {
    
    let birthDay = BehaviorRelay(value: Date())
    
    let year = PublishRelay<Int>()
    let month = PublishRelay<Int>()
    let day = PublishRelay<Int>()
    
    let infoMessage = BehaviorRelay(value: "만 17세 이상만 가입 가능합니다")
    let validation = BehaviorRelay(value: false)
    
    let nextButtonClicked = PublishRelay<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {
        birthDay            
            .subscribe(with: self) { owner, date in
            let nowComponent = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let pickerComponent = Calendar.current.dateComponents([.year, .month, .day], from: date)

            if nowComponent.year! - pickerComponent.year! >= 19 {
                owner.validation.accept(true)
            } else if nowComponent.year! - pickerComponent.year! == 18 {
                if nowComponent.month! < pickerComponent.month! {
                    owner.validation.accept(false)
                } else if nowComponent.month! == pickerComponent.month! {
                    if nowComponent.day! < pickerComponent.day! {
                        owner.validation.accept(false)
                    } else {
                        owner.validation.accept(true)
                    }
                } else {
                    owner.validation.accept(true)
                }
            } else {
                owner.validation.accept(false)
            }

            owner.year.accept(pickerComponent.year!)
            owner.month.accept(pickerComponent.month!)
            owner.day.accept(pickerComponent.day!)
        }
        .disposed(by: disposeBag)
            
    }
    
}
