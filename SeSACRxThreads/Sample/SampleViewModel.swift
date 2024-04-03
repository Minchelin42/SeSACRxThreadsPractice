//
//  SampleViewModel.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/04.
//

import Foundation
import RxSwift
import RxCocoa

class SampleViewModel {

    var list = ["Den", "Jack", "Hue", "Bran"]
    lazy var items = BehaviorSubject(value: list)
    
    let selectedIndex = PublishSubject<Int>()
    let plusButtonClicked = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {
        selectedIndex
            .subscribe(with: self) { owner, value in
                owner.list.remove(at: value)
                owner.items.onNext(owner.list)
            }
            .disposed(by: disposeBag)
    }
    
    
}
