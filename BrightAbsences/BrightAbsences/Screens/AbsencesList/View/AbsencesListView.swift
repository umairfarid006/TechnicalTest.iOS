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
            List(absencesList, id:\.id) { absence in
                AbsenceRowView(absence: absence)
            }
            .navigationTitle("Absence List")
            .task {
                await viewModel.fetchAbsenceList()
                absencesList = viewModel.absenceList
            }
            .searchable(
                text: $searchText,
                prompt: "Search employee"
            )
            .onChange(of: searchText, { oldValue, newValue in
                filterAbsences(using: newValue)
            })
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
