//
//  RootView.swift
//  BrightAbsences
//
//  Created by Umair on 09/08/2026.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var coordinator : NavigationCoordinator
    
    var body: some View {
        
        NavigationStack(path: $coordinator.path) {
            AbsencesListView(viewModel: AbsencesListViewModel(absenceList: [], manager: NetworkManager(session: URLSession.shared)))
                .navigationDestination(for: AppRoute.self) { route in
                    switch route{
                    case .employeeAbsence(let absences):
                        EmployeeAbsencesView(absences: absences)
                    }
                }
        }
    }
}

#Preview {
    RootView()
}
