//
//  ViewController.swift
//  Counter VoiceOverTest
//
//  Created by Alisher Tulembekov on 19.11.2024.
//

import UIKit
import SnapKit

class CounterViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Оформите заказ счетчика"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = true
        label.accessibilityLabel = "Оформите заказ счетчика"
        return label
    }()
    
    lazy var statusView: ExpandableViewTitle = {
        let view = ExpandableViewTitle()
        view.id = "counterView"
        view.titleLabel.text = "Выберите тип счетчика"
        view.expandableView.selectedItem = "-Выберите тип счетчика-"
        view.expandableView.items = CounterType.allCases.map { $0.rawValue }
        view.isAccessibilityElement = true
        view.accessibilityLabel = "Выберите тип счетчика"
        return view
    }()
    
    lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.isAccessibilityElement = true
        date.accessibilityLabel = "Выберите дату"
        return date
    }()

    lazy var textField: TextFieldTitle = {
        let field = TextFieldTitle()
        field.titleLabel.text = "Комментарий клиента"
        field.titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        field.titleLabel.adjustsFontForContentSizeCategory = true
        field.textField.adjustsFontForContentSizeCategory = true
        field.isAccessibilityElement = true
        field.accessibilityLabel = "Комментарий клиента"
        return field
    }()
    
    lazy var buttonView: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = UIColor(red: 40/255, green: 177/255, blue: 212/255, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Отправить заказ"
        button.accessibilityTraits = .button
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statusView, datePicker, textField, buttonView])
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.isAccessibilityElement = false
        stackView.shouldGroupAccessibilityChildren = true
        return stackView
    }()

    var interactor: CounterBusinessLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        setUpConstraints()
        setupInteractor()
    }
    
    func setUpViews() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
    }

    func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func setupInteractor() {
        let interactor = CounterInteractor()
        let presenter = CounterPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
        self.interactor = interactor
    }
    
    @objc func didTapSendButton() {
        let type = CounterType(rawValue: statusView.expandableView.selectedItem ?? "") ?? .gas
        let date = datePicker.date
        let comment = textField.textField.text ?? ""
        let request = CounterData.Request(type: type, date: date, comment: comment)
        interactor?.sendCounterData(request: request)
        UIAccessibility.post(notification: .announcement, argument: "Заявка отправлена")
    }
}

extension CounterViewController: CounterDisplayLogic {
    func displaySubmissionResult(viewModel: CounterData.ViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        UIAccessibility.post(notification: .announcement, argument: viewModel.message)
    }
}
