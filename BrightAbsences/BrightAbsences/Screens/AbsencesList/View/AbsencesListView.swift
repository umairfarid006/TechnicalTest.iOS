//
//  AbsencesListView.swift
//  BrightAbsences
//
//  Created by Umair on 06/08/2026.
//

import SwiftUI

struct AbsencesListView <vm : AbsencesListViewModelProtocol>: View {
    @StateObject private var viewModel : vm
    @State private var searchText = ""
    @State var absencesList : [Absence] = []
    
    init(viewModel: vm) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage) {
                        Task {
                            await viewModel.fetchAbsenceList()
                            absencesList = viewModel.absenceList
                        }
                    }
                } else {
                    List(absencesList, id:\.id) { absence in
                        AbsenceRowView(absence: absence)
                    }
                    .navigationTitle("Absence List")
                    .searchable(
                        text: $searchText,
                        prompt: "Search employee"
                    )
                    .onChange(of: searchText, { oldValue, newValue in
                        filterAbsences(using: newValue)
                    })
                }
            }
        }
        .task {
            await viewModel.fetchAbsenceList()
            absencesList = viewModel.absenceList
        }
    }

    private func filterAbsences(using searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            absencesList = viewModel.absenceList
            return
        }

        absencesList = viewModel.absenceList.filter {
            $0.employee.fullName.localizedCaseInsensitiveContains(searchText)
        }
    }
}

#Preview {
    AbsencesListView(viewModel: AbsencesListViewModel(absenceList: [], manager: NetworkManager(session: URLSession.shared)))
}
