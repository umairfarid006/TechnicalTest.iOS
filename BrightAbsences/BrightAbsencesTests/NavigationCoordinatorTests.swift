//
//  NavigationCoordinatorTests.swift
//  BrightAbsences
//
//  Created by Umair on 09/08/2026.
//

import Testing
import SwiftUI
@testable import BrightAbsences

@MainActor
struct NavigationCoordinatorTests {

    @Test
    func whenPushedSuccessfully() {
        let sut = NavigationCoordinator(
            path: NavigationPath()
        )
        sut.push(.employeeAbsence([]))
        #expect(sut.path.count == 1)
    }

    @Test
    func whenPopSuccessfully() {
        let sut = NavigationCoordinator(
            path: NavigationPath()
        )
        sut.push(.employeeAbsence([]))
        sut.pop()
        #expect(sut.path.count == 0)
    }

    @Test
    func whenPopToRootSuccessfully() {
        let sut = NavigationCoordinator(
            path: NavigationPath()
        )

        sut.push(.employeeAbsence([]))
        sut.push(.employeeAbsence([]))
        sut.push(.employeeAbsence([]))

        sut.popToRoot()

        #expect(sut.path.count == 0)
    }

    @Test
    func whenPopLastSuccessfully() {
        let sut = NavigationCoordinator(
            path: NavigationPath()
        )

        sut.push(.employeeAbsence([]))
        sut.push(.employeeAbsence([]))
        sut.push(.employeeAbsence([]))

        sut.popLast(2)

        #expect(sut.path.count == 1)
    }
}
