//
//  RunViewModel.swift
//  RunMate
//
//  Created by Prashant Pukale on 7/18/21.
//

import Combine
import CoreLocation
import os.log
import MapKit
import SwiftUI

final class StartRunViewModel: ObservableObject {
    private let locationService = LocationService()
    private let permissionService = LocationPermissionService()
    @Published var locationRegion: MKCoordinateRegion = .init()
    @Published var enableStartButton: Bool = false
    private var disposeBag = Set<AnyCancellable>()
    
    func startRun(router: AppRouter) {
        router.go(to: .runCountdown)
    }
    
    func onAppear() {
        permissionService.askPermission()
            .sink { [weak self] status in
                guard let self = self else { return }
                guard status == .grantedPermission else {
                    self.enableStartButton = false
                    return
                }
                self.enableStartButton = true
                try? self.locationService.start()
                    .sink { location in
                        guard let coordinate = location?.coordinate else { return }
                        self.locationRegion = .init(center: coordinate,
                                                    span: .init(latitudeDelta: 0.005, longitudeDelta: 0.005))
                    }.store(in: &self.disposeBag)
            }.store(in: &disposeBag)
    }
}
