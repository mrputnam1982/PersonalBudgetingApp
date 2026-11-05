//
//  ContentView.swift
//  PersonalBudgetingApp
//
//  Created by Mike Putnam on 9/19/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    private let buttonWidth: CGFloat = 100
    var body: some View {
            NavigationStack {
                ZStack {
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ).ignoresSafeArea()
                    VStack(spacing: 0) {
                        // Hero
                        VStack {
                            Text("Budgeting App".uppercased())
                                .kerning(1)
                                .foregroundStyle(.yellow)
                                .font(.system(.caption, weight: .medium).width(.expanded))
                            Text("Enhance Your Cash Flow")
                                .foregroundStyle(.white)
                                .font(.system(.largeTitle, design: .serif, weight: .ultraLight))
                        }
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .frame(height: 300)
                        .clipped()
                        Spacer()
                        // Test
                        VStack {
                            Text("Actions To Explore".uppercased())
                                .kerning(1)
                                .foregroundStyle(.yellow)
                                .font(.system(.caption, weight: .medium).width(.expanded))
                            
                            GeometryReader { proxy in
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack(spacing: 16) {
                                        ForEach(AppContextSelection.allCases) { section in
                                            NavigationLink(value: section) {
                                                SectionButton(section: section)
                                            }
                                        }.scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
                                            content
                                            
                                                .scaleEffect(1 - abs(phase.value) * 0.4)
                                                .opacity(1 - abs(phase.value) * 0.5)
                                            
                                        }
                                    }.scrollTargetLayout()
                                }
                                .scrollTargetBehavior(.viewAligned)
                                .safeAreaPadding(.horizontal, max(0, (proxy.size.width - buttonWidth) / 2))
                                // rest of the landing page content below...
                            }.padding(10)
                                .navigationDestination(for: AppContextSelection.self) { section in
                                    destinationView(for: section)
                                }
                        }
                        //                    .frame(maxWidth: .infinity, maxHeight: 125)
                        .clipped()
                        .padding(.bottom, 40)
                    }
                    VStack {
                        Spacer()
                        Text("Add Account") .kerning(1)
                            .foregroundStyle(.black)
                            .font(.system(.caption, weight: .medium).width(.expanded))
                        NavigationStack {
                            NavigationLink {
                                //DetailView()
                                
                            } label: {
                                Image(systemName: "plus").resizable().frame(width: 50, height: 50) .kerning(1).foregroundStyle(.black)
                            }
                           
                        }
                    }
                }
            
        }
    }
    
    @ViewBuilder
    private func destinationView(for section: AppContextSelection) -> some View {
        switch section {
            
        case .accounts, .transactions, .budgets, .goals, .reports, .settings: AccountsView()
            //        case .transactions: TransactionsView()
            //        case .budgets: BudgetsView()
            //        case .goals: GoalsView()
            //        case .reports: ReportsView()
            //        case .settings: SettingsView()
            //        }
        }
        
    }
}

struct SectionButton: View {
    let section: AppContextSelection

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: section.icon)
                .font(.title2)
            Text(section.title)
                .font(.caption)
        }
        .frame(width: 100, height: 100)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
    
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
