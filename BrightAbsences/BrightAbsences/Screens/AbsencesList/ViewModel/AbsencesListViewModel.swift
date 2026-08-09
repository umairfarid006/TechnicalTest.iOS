//
//  AbsencesListViewModel.swift
//  BrightAbsences
//
//  Created by Umair on 06/08/2026.
//

import Observation
import Combine
import Foundation

protocol AbsencesListViewModelProtocol: ObservableObject{
    var absenceList : [Absence] { get set }
    var errorMessage : String? { get set }
    var isLoading: Bool { get set }
    func fetchAbsenceList() async
    func sortAbsences(option: AbsenceSortOption) -> [Absence]
}

final class AbsencesListViewModel: ObservableObject, AbsencesListViewModelProtocol{
    
    // service end points
    enum endopoints : String{
        case absences = "absences"
        case conflict = "conflict"
    }
    
    // properties
    let manager : NetworkManager
    @Published var absenceList : [Absence]
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    init(absenceList: [Absence], manager: NetworkManager) {
        self.absenceList = absenceList
        self.manager = manager
    }
    
    func fetchAbsenceList() async{
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        do{
            absenceList = try await manager.executeRequest(urlString: AppConstants.baseURL + endopoints.absences.rawValue, params: nil)
            absenceList = await updateConflictStatus(absences: absenceList)
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
    private func updateConflictStatus(absences: [Absence]) async -> [Absence] {
        await withTaskGroup(of: (Int, Absence).self) { group in
            for (index, absence) in absences.enumerated() {
                group.addTask {
                    var updatedAbsence = absence
                    updatedAbsence.hasConflict = await self.fetchConflicts(id: absence.id)
                    return (index, updatedAbsence)
                }
            }
            var results: [(Int, Absence)] = []
            for await result in group {
                results.append(result)
            }
            return results.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
    
    private func fetchConflicts(id: Int) async -> Bool {
        do {
            let conflict: Conflict = try await manager.executeRequest(urlString: AppConstants.baseURL + endopoints.conflict.rawValue + "/\(id)")
            return conflict.conflicts
        } catch {
            return false
        }
    }
    
    func sortAbsences(option: AbsenceSortOption) -> [Absence] {
        absenceList.sorted { lhs, rhs in
            switch option {
            case .date:
                return (lhs.startDate.toDate ?? .distantFuture)
                    < (rhs.startDate.toDate ?? .distantFuture)

            case .absenceType:
                return lhs.absenceType.title
                    .localizedCaseInsensitiveCompare(rhs.absenceType.title)
                    == .orderedAscending

            case .name:
                return lhs.employee.fullName
                    .localizedCaseInsensitiveCompare(rhs.employee.fullName)
                    == .orderedAscending
            }
        }
    }
}
