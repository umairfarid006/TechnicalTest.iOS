# BrightAbsences

BrightAbsences is a small SwiftUI application that retrieves employee absence data from an API, displays the absences in a searchable list, checks each absence for conflicts, and allows the user to view all absences belonging to a selected employee.

The project was created as part of the BrightHR iOS Developer technical assessment.

## Requirements

* Swift
* SwiftUI
* Async/Await
* iOS 16+
* Xcode 26.x

## Architecture

The project uses an MVVM-style architecture with a lightweight coordinator for navigation.

The main responsibilities are separated into:

* **Views** – SwiftUI presentation and user interaction
* **ViewModels** – state management and business logic
* **NetworkManager** – networking and decoding
* **Models** – API/domain models
* **NavigationCoordinator** – navigation state and routing
* **Extensions** – reusable formatting and conversion helpers

Dependency injection is used for networking so that the application can be tested without performing real network requests.

## Main Features

### Absence List

The application retrieves the list of employee absences from the provided API and displays them using SwiftUI `List`.

Each row displays the relevant absence and employee information.

The screen supports:

* Loading state
* Error state with retry
* Employee search
* Sorting
* Conflict indication
* Navigation to an employee's absence history

### Search

Employees can be searched by name.

Search is case-insensitive and filters the already retrieved absence list.

### Sorting

Absences can be sorted using the menu in the navigation bar.

Available options are:

* Date
* Absence type
* Employee name
* Show all

Dates returned by the API are provided as strings, for example:

```text
2021-05-07T06:59:09.969Z
```

The value is converted to `Date` before chronological sorting rather than relying on string comparison.

### Conflict Checking

After the initial absence list is retrieved, the application checks the conflict endpoint for each absence.

Conflict requests are executed concurrently using Swift structured concurrency and `withTaskGroup`.

The original order of the absence list is retained after the concurrent requests complete.

If an individual conflict request fails, the absence is treated as having no conflict rather than failing the complete absence list request.

### Employee Absence History

Selecting an absence filters the list using the employee's unique identifier and navigates to a screen showing all absences belonging to that employee.

The employee ID is used rather than the employee name because names are not guaranteed to be unique.

## Networking

Networking is handled by `NetworkManager`.

The manager supports generic `Decodable` responses:

```swift
func executeRequest<T: Decodable>(
    urlString: String,
    method: HttpMethods = .get,
    params: Encodable? = nil
) async throws -> T
```

The networking layer handles:

* URL validation
* HTTP methods
* JSON request encoding
* HTTP response validation
* JSON response decoding
* Application-specific errors

`URLSession` is abstracted behind `URLSessionProtocol`:

```swift
protocol URLSessionProtocol {
    func data(
        for request: URLRequest,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse)
}
```

This allows a mocked session to be injected during unit testing without making real API requests.

## Error Handling

The networking layer maps common failures to `AppErrors`.

```swift
enum AppErrors: LocalizedError {
    case badUrl
    case invalidParams
    case invalidResponse
    case invalidData
    case unKnown
}
```

Errors from the initial absence request are exposed by the view model and presented by the UI.

The user can retry the request from the error state.

## Navigation

Navigation is handled using `NavigationStack` and a `NavigationCoordinator`.

The coordinator owns a `NavigationPath` and provides reusable navigation methods including:

* `push`
* `pop`
* `popLast`
* `popToRoot`

The root view owns the application's `NavigationStack`, avoiding nested navigation stacks.

Routes are represented by `AppRoute`.

## Testing

The project contains unit and snapshot tests.

### Swift Testing

The newer Swift Testing framework is used for unit tests.

View model tests cover:

* Successful absence retrieval
* Failed absence retrieval
* Conflict detection
* Conflict request failure
* Sorting by date
* Sorting by employee name
* Sorting by absence type

Network manager tests cover:

* Successful response decoding
* Invalid URL
* Invalid HTTP response
* Invalid response data

Navigation coordinator tests cover:

* Push
* Pop
* Pop to root
* Removing multiple routes

Dependency injection through `URLSessionProtocol` allows these tests to run without accessing the real API.

### Snapshot Testing

Snapshot tests are included for important SwiftUI states, including:

* Normal absence row
* Absence row with conflict
* Absence list loaded state

Snapshots use a fixed device configuration to provide predictable rendering.

Snapshot tests should be run using a consistent simulator runtime and orientation because SwiftUI rendering may differ between simulator versions.

## Concurrency

The project uses Swift concurrency throughout the networking flow.

The absence list is retrieved asynchronously using `async/await`.

Conflict requests are performed concurrently:

```swift
await withTaskGroup(of: (Int, Absence).self)
```

Each task returns the original index together with the updated absence. The results are reordered using that index before being returned so that asynchronous completion does not change the original API ordering.

UI-related state is kept on the main actor where required.

## Design Decisions

### Keeping API Dates as Strings

The API model currently keeps `startDate` in its original string representation.

A reusable string extension converts the API value into `Date` when date operations such as sorting are required.

This keeps API decoding simple while still allowing date-aware comparisons.

### Conflict Failure Behaviour

A failure from the main absence endpoint is presented as an application error.

An individual conflict endpoint failure does not prevent the absence list from being displayed. In that situation `hasConflict` defaults to `false`.

This provides a better user experience because supplementary conflict information should not prevent the primary absence data from being shown.

### Coordinator Navigation

Navigation logic is kept outside individual views using a coordinator.

This reduces navigation responsibilities inside SwiftUI views and provides a central place for future routes.

## Running the Project

1. Clone the repository.
2. Open the project in Xcode.
3. Select an iOS simulator.
4. Build and run the application.

No additional configuration should be required if the provided API is available.

## Running Tests

Unit tests can be run using:

**Product → Test**

or:

```text
⌘U
```

Snapshot tests should be run using a consistent simulator/iOS runtime to avoid rendering differences between reference and newly generated snapshots.

## Summary

The project focuses on demonstrating:

* Modern Swift and SwiftUI
* MVVM separation
* Dependency injection
* Generic networking
* Async/Await
* Structured concurrency
* Error and loading states
* Search and sorting
* Coordinator-based navigation
* Unit testing
* Snapshot testing

The implementation intentionally remains lightweight while keeping the main responsibilities separated and testable.

