//
//  AbsencesListViewSnapshotTests.swift
//  BrightAbsences
//
//  Created by Umair on 08/08/2026.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import BrightAbsences

final class AbsencesListViewSnapshotTests: XCTestCase {

    func test_absenceList_loadedState() {

        let absences: [Absence] = [.mock, .mock, .mock]
        let viewModel = MockAbsencesListViewModel()
        viewModel.absenceList = absences
        let view = AbsencesListView(
            viewModel: viewModel,
            absencesList: absences
        )
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}
