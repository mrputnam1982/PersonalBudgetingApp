//
//  AppContextSelection.swift
//  PersonalBudgetingApp
//
//  Created by Mike Putnam on 9/19/26.
//

import Foundation
enum AppContextSelection: String, CaseIterable, Identifiable {
    case accounts, transactions, budgets, goals, reports, settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .accounts: return "Accounts"
        case .transactions: return "Transactions"
        case .budgets: return "Budgets"
        case .goals: return "Goals"
        case .reports: return "Reports"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .accounts: return "creditcard"
        case .transactions: return "list.bullet.rectangle"
        case .budgets: return "chart.pie"
        case .goals: return "target"
        case .reports: return "chart.bar"
        case .settings: return "gearshape"
        }
    }
}
