//
//  NetworkMangerTests.swift
//  BrightAbsences
//
//  Created by Umair on 09/08/2026.
//

import Testing
import Foundation
@testable import BrightAbsences

@MainActor
struct NetworkManagerTests {

    @Test
    func executeRequest_whenResponseIsValid_decodesModel() async throws {
        let mockSession = MockURLSession()

        let json = """
        {
            "conflicts": true
        }
        """

        let data = Data(json.utf8)

        let url = URL(string: "https://example.com/conflict")!

        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        mockSession.requestHandler = { _ in
            (data, response)
        }

        let sut = NetworkManager(session: mockSession)

        let result: Conflict = try await sut.executeRequest(
            urlString: "https://example.com/conflict"
        )

        #expect(result.conflicts == true)
    }


    @Test
    func executeRequest_whenURLIsInvalid_throwsBadUrl() async {
        let mockSession = MockURLSession()
        let sut = NetworkManager(session: mockSession)

        do {
            let _: Conflict = try await sut.executeRequest(
                urlString: "invalid-url"
            )

            Issue.record("Expected badUrl error")
        } catch let error as AppErrors {
            #expect(error == .badUrl)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }


    @Test
    func executeRequest_whenStatusCodeIsNotSuccessful_throwsInvalidResponse() async {
        let mockSession = MockURLSession()

        mockSession.requestHandler = { request in
            let url = request.url!

            let response = HTTPURLResponse(
                url: url,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!

            return (Data(), response)
        }

        let sut = NetworkManager(session: mockSession)

        do {
            let _: Conflict = try await sut.executeRequest(
                urlString: "https://example.com/conflict"
            )

            Issue.record("Expected invalidResponse error")
        } catch let error as AppErrors {
            #expect(error == .invalidResponse)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }


    @Test
    func executeRequest_whenDataIsInvalid_throwsInvalidData() async {
        let mockSession = MockURLSession()

        mockSession.requestHandler = { request in
            let url = request.url!

            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            let invalidData = Data("invalid json".utf8)

            return (invalidData, response)
        }

        let sut = NetworkManager(session: mockSession)

        do {
            let _: Conflict = try await sut.executeRequest(
                urlString: "https://example.com/conflict"
            )

            Issue.record("Expected invalidData error")
        } catch let error as AppErrors {
            #expect(error == .invalidData)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
