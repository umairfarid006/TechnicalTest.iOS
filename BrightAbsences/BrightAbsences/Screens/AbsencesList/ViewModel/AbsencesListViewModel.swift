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
}

final class AbsencesListViewModel: ObservableObject, AbsencesListViewModelProtocol{
    
    // service end points
    enum endopoints : String{
        case absences = "absences"
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
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
