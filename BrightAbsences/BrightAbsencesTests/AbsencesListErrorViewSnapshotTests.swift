//
//  AbsencesListErrorViewSnapshotTests.swift
//  BrightAbsences
//
//  Created by Umair on 08/08/2026.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import BrightAbsences

final class AbsencesListErrorViewSnapshotTests: XCTestCase {
    func test_absenceList_when_Falilure() {
        let absences: [Absence] = [.mock, .mock, .mock]
        let viewModel = MockAbsencesListViewModel()
        viewModel.errorMessage = "Not able to load data"
        let view = AbsencesListView(
            viewModel: viewModel,
            absencesList: absences
        )
            .environment(\.colorScheme, .light)
            .environment(\.locale, Locale(identifier: "en_GB"))
            .environment(\.sizeCategory, .medium)

        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .device(config: .iPhone13)))
    }
}
