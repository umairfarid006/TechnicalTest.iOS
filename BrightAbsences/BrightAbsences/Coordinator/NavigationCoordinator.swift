//
//  NavigationCoordinator.swift
//  BrightAbsences
//
//  Created by Umair on 09/08/2026.
//

import SwiftUI
import Combine

final class NavigationCoordinator: ObservableObject{
    @Published var path : NavigationPath
    
    init(path: NavigationPath) {
        self.path = path
    }
    
    func push(_ route: AppRoute){
        path.append(route)
    }
    
    func pop(){
        path.removeLast()
    }
    
    func popLast(_ count: Int){
        guard !path.isEmpty else {return}
        let safeCount = min(count, path.count)
        path.removeLast(safeCount)
    }
    
    func popToRoot(){
        path.removeLast(path.count)
    }
}
