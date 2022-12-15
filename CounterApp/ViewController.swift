//
//  ViewController.swift
//  RecordApp
//
//  Created by Conner on 2022/12/15.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class ViewController: UIViewController, StoryboardView {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")

        activityIndicatorView.layer.zPosition = 10
        activityIndicatorView.backgroundColor = UIColor.red
    }
    
    func bind(reactor: CounterViewReactor) {
        self.bindAction(reactor)
        self.bindState(reactor)
    }
    
    private func bindAction(_ reactor: CounterViewReactor) {
        increaseButton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: CounterViewReactor) {
        reactor.state
            .map { String($0.value) }
            .distinctUntilChanged()
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .map{ !$0}
            .distinctUntilChanged()
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

