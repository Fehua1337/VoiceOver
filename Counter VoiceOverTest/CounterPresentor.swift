//
//  CounterPresentor.swift
//  Counter VoiceOverTest
//
//  Created by Alisher Tulembekov on 19.11.2024.
//

import Foundation

protocol CounterPresentationLogic {
    func presentSubmissionResult(response: CounterData.Response)
}

class CounterPresenter: CounterPresentationLogic {
    weak var viewController: CounterDisplayLogic?
    
    func presentSubmissionResult(response: CounterData.Response) {
        let title = response.success ? "Успех" : "Ошибка"
        let message = response.success ? "Данные успешно отправлены!" : "Не удалось отправить данные. Попробуйте еще раз."
        let viewModel = CounterData.ViewModel(title: title, message: message)
        viewController?.displaySubmissionResult(viewModel: viewModel)
    }
}
