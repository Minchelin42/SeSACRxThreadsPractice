//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/02.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    
    var list: [Wish] = []
    var nowList: [Wish] = []
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let inputSearch: ControlProperty<String?>
        let inputShopping: ControlProperty<String?>
        
        let searchButtonClicked: ControlEvent<Void>
        let inputButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let items: PublishSubject<[Wish]>
    }
    
    func transform(input: Input) -> Output {
        
        let items = PublishSubject<[Wish]>()
        
        input.inputSearch
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.list : owner.list.filter{ $0.title.contains(value)}
                owner.nowList = result
                items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonClicked
            .withLatestFrom(input.inputSearch.orEmpty)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.list : owner.list.filter{ $0.title.contains(value)}
                owner.nowList = result
                items.onNext(result)
            }
            .disposed(by: disposeBag)

        input.inputButtonClicked
            .withLatestFrom(input.inputShopping.orEmpty)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                owner.list.append(Wish(title: value))
                owner.nowList = owner.list
                items.onNext(owner.list)
            }
            .disposed(by: disposeBag)

        return Output(items: items)
    }

}
