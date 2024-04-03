//
//  ShoppingEditViewModel.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/03.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingEditViewModel {
    
    let inputEdit = PublishSubject<String>()
    let editButtonClicked = PublishSubject<Void>()
    let deleteButtonClicked = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {

    }

}
