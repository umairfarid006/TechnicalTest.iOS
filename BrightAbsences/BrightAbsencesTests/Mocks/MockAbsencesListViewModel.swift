//
//  MockAbsencesListViewModel.swift
//  BrightAbsences
//
//  Created by Umair on 08/08/2026.
//

import Combine
@testable import BrightAbsences

final class MockAbsencesListViewModel:
    AbsencesListViewModelProtocol {

    @Published var absenceList: [Absence] = []

    var errorMessage: String?
    var isLoading: Bool = false

    func fetchAbsenceList() async { }
}
