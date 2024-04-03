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
    
    var list = [Wish(title: "트랙패드"), Wish(title: "아이패드"), Wish(title: "폰케이스"), Wish(title: "그립톡")]
    
    //검색어
    let inputShopping = PublishSubject<String>()
    //텍스트필드 쇼핑
    let inputSearch = PublishSubject<String>()
    //검색버튼 클릭
    let searchButtonClicked = PublishSubject<Void>()
    //추가버튼 클릭
    let inputButtonClicked = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    lazy var items = BehaviorSubject(value: list)
    
    init(){

        inputSearch
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("실시간 검색: \(value)")
                let result = value.isEmpty ? owner.list : owner.list.filter{ $0.title.contains(value)}
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        searchButtonClicked
            .withLatestFrom(inputSearch)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("검색 버튼 클릭: \(value)")
                let result = value.isEmpty ? owner.list : owner.list.filter{ $0.title.contains(value)}
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)

        inputButtonClicked
            .withLatestFrom(inputShopping)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("추가 버튼 클릭: \(value)")
                owner.list.append(Wish(title: value))
                owner.items.onNext(owner.list)
            }
            .disposed(by: disposeBag)
    }
    
    
}
