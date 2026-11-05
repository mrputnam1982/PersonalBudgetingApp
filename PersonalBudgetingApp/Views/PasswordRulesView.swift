//
//  PasswordRulesView.swift
//  PersonalBudgetingApp
//
//  Created by Mike Putnam on 11/4/26.
//

import SwiftUI

struct PasswordRulesView: View {
    let password: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6)
        {
            ForEach(PasswordRule.allCases){
                rule in
                let ok = rule.isSatisfied(by: password)
                Label(rule.message, systemImage:    ok ? "checkmark.fill" : "xmark.circle").foregroundStyle(ok ? .green : .secondary)
                    .font(.footnote)
                
            }
        }.animation(.default, value: password)
    }
}


