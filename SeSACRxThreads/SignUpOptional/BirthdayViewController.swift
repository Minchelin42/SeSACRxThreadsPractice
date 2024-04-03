//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BirthdayViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel = UILabel()
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayModel()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
       
    }

    private func bind() {
        
        nextButton.rx.tap
            .bind(to: viewModel.nextButtonClicked)
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .bind(to: viewModel.birthDay)
            .disposed(by: disposeBag)
        
        viewModel.nextButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let nav = UINavigationController(rootViewController: SampleViewController())

                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
        
        viewModel.validation
            .subscribe(with: self) { owner, value in
                if value {
                    owner.viewModel.infoMessage.accept("가입 가능한 나이입니다")
                    owner.infoLabel.textColor = .blue
                    owner.nextButton.backgroundColor = .blue
                    owner.nextButton.isEnabled = true
                } else {
                    owner.viewModel.infoMessage.accept("만 17세 이상만 가입 가능합니다")
                    owner.infoLabel.textColor = .red
                    owner.nextButton.backgroundColor = .lightGray
                    owner.nextButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.infoMessage
            .asDriver()
            .drive(with: self) { owner, value in
                owner.infoLabel.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel.year
            .asDriver(onErrorJustReturn: 2024)
            .map { "\($0)년" }
            .drive(with: self) { owner, value in
                owner.yearLabel.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel.month
            .asDriver(onErrorJustReturn: 4)
            .map { "\($0)월" }
            .drive(with: self) { owner, value in
                owner.monthLabel.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel.day
            .asDriver(onErrorJustReturn: 2)
            .map { "\($0)일" }
            .drive(with: self) { owner, value in
                owner.dayLabel.text = value
            }
            .disposed(by: disposeBag)
    }

    
    private func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
