//
//  AbsenceRowViewSnapshotTests.swift
//  BrightAbsences
//
//  Created by Umair on 08/08/2026.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import BrightAbsences

final class AbsenceRowViewSnapshotTests: XCTestCase {
    func test_absenceRow() {
        let view = AbsenceRowView(absence: .mock)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
    
    func test_absenceRow_when_conflict() {
        let view = AbsenceRowView(absence: .mockWithConflict)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}
