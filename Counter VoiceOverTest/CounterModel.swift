//
//  CounterModel.swift
//  Counter VoiceOverTest
//
//  Created by Alisher Tulembekov on 19.11.2024.
//

import Foundation

enum CounterData {
    struct Request {
        let type: CounterType
        let date: Date
        let comment: String
    }
    
    struct Response {
        let success: Bool
    }
    
    struct ViewModel {
        let title: String
        let message: String
    }
}

// MARK: - Display Logic Protocol
protocol CounterDisplayLogic: AnyObject {
    func displaySubmissionResult(viewModel: CounterData.ViewModel)
}

// MARK: - Models
enum CounterType: String, CaseIterable {
    case gas = "Газовый"
    case water = "Водяной"
    case electric = "Электрический"
}

struct CounterModel: Identifiable {
    let id: UUID = UUID()
    let type: CounterType
    let date: Date
    let comment: String
}

struct CounterAPIResponse: Decodable {
    let success: Bool
}
