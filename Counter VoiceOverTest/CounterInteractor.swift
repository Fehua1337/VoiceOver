//
//  CounterInteractor.swift
//  Counter VoiceOverTest
//
//  Created by Alisher Tulembekov on 19.11.2024.
//

import Foundation
import Alamofire

protocol CounterBusinessLogic {
    func sendCounterData(request: CounterData.Request)
}

class CounterInteractor: CounterBusinessLogic {
    var presenter: CounterPresentationLogic?
    
    func sendCounterData(request: CounterData.Request) {
        // Использование Alamofire для отправки данных на сервер
        let parameters: [String: Any] = [
            "type": request.type.rawValue,
            "date": request.date.timeIntervalSince1970,
            "comment": request.comment
        ]
        
        AF.request("https://example.com/api/counter", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: CounterAPIResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    let success = apiResponse.success
                    let response = CounterData.Response(success: success)
                    self.presenter?.presentSubmissionResult(response: response)
                case .failure:
                    let response = CounterData.Response(success: false)
                    self.presenter?.presentSubmissionResult(response: response)
                }
            }
    }
}
