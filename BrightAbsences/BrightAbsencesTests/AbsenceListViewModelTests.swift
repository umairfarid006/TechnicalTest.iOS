//
//  AbsenceListViewModelTests.swift
//  BrightAbsences
//
//  Created by Umair on 09/08/2026.
//

import Testing
import Foundation
@testable import BrightAbsences

@MainActor
struct AbsenceListViewModelTests {

    // MARK: - Fetch Tests

    @Test
    func fetchAbsenceList_whenRequestSucceeds_returnsAbsences() async throws {

        let mockSession = MockURLSession()

        mockSession.requestHandler = { request in

            guard let url = request.url else {
                throw AppErrors.badUrl
            }

            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            if url.absoluteString.contains("conflict") {

                let data = """
                {
                    "conflicts": false
                }
                """.data(using: .utf8)!

                return (data, response)
            }

            let data = """
            [
                {
                    "id": 1,
                    "startDate": "2021-05-07T06:59:09.969Z",
                    "days": 2,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "1",
                        "firstName": "John",
                        "lastName": "Smith"
                    }
                }
            ]
            """.data(using: .utf8)!

            return (data, response)
        }

        let sut = makeSUT(session: mockSession)

        await sut.fetchAbsenceList()

        #expect(sut.absenceList.count == 1)
        #expect(sut.absenceList.first?.id == 1)
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }


    @Test
    func fetchAbsenceList_whenRequestFails_setsErrorMessage() async {

        let mockSession = MockURLSession()

        mockSession.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        let sut = makeSUT(session: mockSession)

        await sut.fetchAbsenceList()

        #expect(sut.errorMessage != nil)
        #expect(sut.absenceList.isEmpty)
        #expect(sut.isLoading == false)
    }


    @Test
    func fetchAbsenceList_whenConflictExists_setsHasConflictTrue() async throws {

        let mockSession = MockURLSession()

        mockSession.requestHandler = { request in

            guard let url = request.url else {
                throw AppErrors.badUrl
            }

            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            if url.absoluteString.contains("conflict") {

                let data = """
                {
                    "conflicts": true
                }
                """.data(using: .utf8)!

                return (data, response)
            }

            let data = """
            [
                {
                    "id": 1,
                    "startDate": "2021-05-07T06:59:09.969Z",
                    "days": 2,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "1",
                        "firstName": "John",
                        "lastName": "Smith"
                    }
                }
            ]
            """.data(using: .utf8)!

            return (data, response)
        }

        let sut = makeSUT(session: mockSession)

        await sut.fetchAbsenceList()

        #expect(sut.absenceList.count == 1)
        #expect(sut.absenceList.first?.hasConflict == true)
    }


    @Test
    func fetchAbsenceList_whenConflictRequestFails_setsConflictFalse() async throws {

        let mockSession = MockURLSession()

        mockSession.requestHandler = { request in

            guard let url = request.url else {
                throw AppErrors.badUrl
            }

            if url.absoluteString.contains("conflict") {
                throw URLError(.badServerResponse)
            }

            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            let data = """
            [
                {
                    "id": 1,
                    "startDate": "2021-05-07T06:59:09.969Z",
                    "days": 2,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "1",
                        "firstName": "John",
                        "lastName": "Smith"
                    }
                }
            ]
            """.data(using: .utf8)!

            return (data, response)
        }

        let sut = makeSUT(session: mockSession)

        await sut.fetchAbsenceList()

        #expect(sut.absenceList.count == 1)
        #expect(sut.absenceList.first?.hasConflict == false)
    }


    // MARK: - Sorting Tests

    @Test
    func sortAbsences_byDate_returnsOldestFirst() throws {

        let absences = try makeAbsences(
            """
            [
                {
                    "id": 1,
                    "startDate": "2023-05-07T06:59:09.969Z",
                    "days": 1,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "1",
                        "firstName": "John",
                        "lastName": "Smith"
                    }
                },
                {
                    "id": 2,
                    "startDate": "2021-05-07T06:59:09.969Z",
                    "days": 1,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "2",
                        "firstName": "Adam",
                        "lastName": "Jones"
                    }
                },
                {
                    "id": 3,
                    "startDate": "2022-05-07T06:59:09.969Z",
                    "days": 1,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "3",
                        "firstName": "Bob",
                        "lastName": "Brown"
                    }
                }
            ]
            """
        )

        let sut = makeSUT(absences: absences)

        let result = sut.sortAbsences(option: .date)

        #expect(result.map(\.id) == [2, 3, 1])
    }


    @Test
    func sortAbsences_byName_returnsAlphabeticalOrder() throws {

        let absences = try makeAbsences(
            """
            [
                {
                    "id": 1,
                    "startDate": "2021-05-07T06:59:09.969Z",
                    "days": 1,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "1",
                        "firstName": "Zara",
                        "lastName": "Smith"
                    }
                },
                {
                    "id": 2,
                    "startDate": "2021-05-07T06:59:09.969Z",
                    "days": 1,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "2",
                        "firstName": "Adam",
                        "lastName": "Jones"
                    }
                },
                {
                    "id": 3,
                    "startDate": "2021-05-07T06:59:09.969Z",
                    "days": 1,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "3",
                        "firstName": "Bob",
                        "lastName": "Brown"
                    }
                }
            ]
            """
        )

        let sut = makeSUT(absences: absences)

        let result = sut.sortAbsences(option: .name)

        #expect(
            result.map(\.employee.fullName) == [
                "Adam Jones",
                "Bob Brown",
                "Zara Smith"
            ]
        )
    }


    @Test
    func sortAbsences_byAbsenceType_returnsAlphabeticalOrder() throws {

        let absences = try makeAbsences(
            """
            [
                {
                    "id": 1,
                    "startDate": "2021-05-07T06:59:09.969Z",
                    "days": 1,
                    "absenceType": "SICKNESS",
                    "approved": true,
                    "employee": {
                        "id": "1",
                        "firstName": "John",
                        "lastName": "Smith"
                    }
                },
                {
                    "id": 2,
                    "startDate": "2021-05-07T06:59:09.969Z",
                    "days": 1,
                    "absenceType": "ANNUAL_LEAVE",
                    "approved": true,
                    "employee": {
                        "id": "2",
                        "firstName": "Adam",
                        "lastName": "Jones"
                    }
                }
            ]
            """
        )

        let sut = makeSUT(absences: absences)

        let result = sut.sortAbsences(option: .absenceType)

        let resultTitles = result.map(\.absenceType.title)

        let expectedTitles = resultTitles.sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }

        #expect(resultTitles == expectedTitles)
    }


    // MARK: - Helpers

    private func makeSUT(
        absences: [Absence] = [],
        session: MockURLSession = MockURLSession()
    ) -> AbsencesListViewModel {

        let networkManager = NetworkManager(
            session: session
        )

        return AbsencesListViewModel(
            absenceList: absences,
            manager: networkManager
        )
    }


    private func makeAbsences(
        _ json: String
    ) throws -> [Absence] {

        guard let data = json.data(using: .utf8) else {
            throw AppErrors.invalidData
        }

        return try JSONDecoder().decode(
            [Absence].self,
            from: data
        )
    }
}


// MARK: - Mock URLSession

final class MockURLSession: URLSessionProtocol {

    var requestHandler:
        ((URLRequest) throws -> (Data, URLResponse))?

    func data(
        for request: URLRequest,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse) {

        guard let requestHandler else {
            throw AppErrors.invalidResponse
        }

        return try requestHandler(request)
    }
}
