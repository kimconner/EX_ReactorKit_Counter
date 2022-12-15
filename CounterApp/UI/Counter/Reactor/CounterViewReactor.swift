//
//  CounterViewReactor.swift
//  RecordApp
//
//  Created by Conner on 2022/12/15.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

final class CounterViewReactor: Reactor {
    
    let initialState = State()
    
    enum Action {
        case increase
        case decrease
    }
    
    // 처리단위
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    
    // 현재 상태를 기록
    struct State {
        var value = 0
        var isLoading = false
    }
    
    // Action이 들어온 경우, 어떤 처리를 할건지 분기
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    // 이전 상태와 처리 단위를 받아서 다음 상태를 반환하는 함수
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}
