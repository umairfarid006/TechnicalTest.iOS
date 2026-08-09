//
//  AbsencesListView.swift
//  BrightAbsences
//
//  Created by Umair on 06/08/2026.
//

import SwiftUI

struct AbsencesListView <vm : AbsencesListViewModelProtocol>: View {
    @EnvironmentObject private var coordinator : NavigationCoordinator
    @StateObject private var viewModel : vm
    @State private var searchText = ""
    @State var absencesList : [Absence]
    
    init(viewModel: vm, absencesList: [Absence] = []) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _absencesList = State(initialValue: absencesList)
    }
    
    var body: some View {
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
                        .onTapGesture {
                            let employeeAbsences = absencesList.filter {
                                $0.employee.fullName == absence.employee.fullName
                            }
                            coordinator.push(.employeeAbsence(employeeAbsences))
                        }
                }
                .navigationTitle("Absence List")
                .searchable(
                    text: $searchText,
                    prompt: "Search employee"
                )
                .onChange(of: searchText, { oldValue, newValue in
                    filterAbsences(using: newValue)
                })
                .toolbar {
                    ToolbarItem {
                        Menu {
                            Button("Sort by date") {
                                absencesList = viewModel.sortAbsences(option: .date)
                            }
                            
                            Button("Sort by absence Type") {
                                absencesList = viewModel.sortAbsences(option: .absenceType)
                            }
                            
                            Button("Sort by Name") {
                                absencesList = viewModel.sortAbsences(option: .name)
                            }
                            
                            Button("Show All") {
                                absencesList = viewModel.absenceList
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
            }
        }
        .task {
            if viewModel.absenceList.isEmpty {
                await viewModel.fetchAbsenceList()
                absencesList = viewModel.absenceList
            }
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
