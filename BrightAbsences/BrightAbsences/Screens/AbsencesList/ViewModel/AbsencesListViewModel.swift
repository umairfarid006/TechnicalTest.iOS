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
    var absenceList : [Absence] {get set}
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
    
    init(absenceList: [Absence], manager: NetworkManager) {
        self.absenceList = absenceList
        self.manager = manager
    }
    
    func fetchAbsenceList() async{
        do{
            absenceList = try await manager.executeRequest(urlString: AppConstants.baseURL + endopoints.absences.rawValue, params: nil)
        }catch{
            print(error.localizedDescription)
        }
    }
}
