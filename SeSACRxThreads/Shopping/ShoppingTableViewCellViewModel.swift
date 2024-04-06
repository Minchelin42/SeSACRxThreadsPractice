//
//  ShoppingTableViewCellViewModel.swift
//  SeSACRxThreads
//
//  Created by 민지은 on 2024/04/04.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingTableViewCellViewModel {
    
    let disposeBag = DisposeBag()
    var list: [Wish] = []
    var nowList: [Wish] = []
    var nowIndex: Int? = nil
    
    struct Input {
        let starButtonClicked: ControlEvent<Void>
        let checkButtonClicked: ControlEvent<Void>
        
    }
    
    struct Output {
        let items: PublishSubject<[Wish]>
    }
    
    func transform(input: Input) -> Output {

        let items = PublishSubject<[Wish]>()
        
        input.starButtonClicked
            .subscribe(with: self) { owner, _ in
                if let index = owner.nowIndex {
                    print("owner nowIndex", index)
                    print("starButton Clicked", owner.nowList)
                    owner.nowList[index].star.toggle()
                    let findIndex = owner.list.firstIndex { value in
                        value.title == owner.nowList[index].title
                    }
                    
                    guard let findIndex = findIndex else { return }
                    owner.list[findIndex].star.toggle()
                    
                    print("starButton Clicked After", owner.nowList)
                    items.onNext(owner.nowList)
                }
            }
            .disposed(by: disposeBag)
        
        input.checkButtonClicked
            .subscribe(with: self) { owner, _ in
                if let index = owner.nowIndex {
                    owner.nowList[index].check.toggle()
                    
                    let findIndex = owner.list.firstIndex { value in
                        value.title == owner.nowList[index].title
                    }
                    guard let findIndex = findIndex else { return }
                    owner.list[findIndex].check.toggle()
                    items.onNext(owner.nowList)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(items: items)
    }
    
}
