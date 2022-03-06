//
//  TimeService.swift
//  RunMate
//
//  Created by Prashant Pukale on 3/6/22.
//

import Foundation
import Combine

protocol TimerProtocol {
    init(interval: TimeInterval)
    func atTimeInterval() -> AnyPublisher<Void, Never>
    func start() -> AnyPublisher<Void, Never>
    func pause(_ pause: Bool)
}

final class RMTimer: TimerProtocol {
    private let timer: Timer.TimerPublisher
    private var disposeBag = Set<AnyCancellable>()
    private var isPaused = true

    private let timerSubject = CurrentValueSubject<Void, Never>(())
    init(interval: TimeInterval = 1) {
        timer = Timer.publish(every: interval,
                              on: .main,
                              in: .common)
    }

    func atTimeInterval() -> AnyPublisher<Void, Never> {
        return timerSubject.eraseToAnyPublisher()
    }

    @discardableResult
    func start() -> AnyPublisher<Void, Never> {
        timer.receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self,
                      !self.isPaused else { return }
                self.timerSubject.send(())
            }.store(in: &disposeBag)

        timer.connect()
            .store(in: &disposeBag)
        isPaused = false
        return timerSubject.eraseToAnyPublisher()
    }

    func pause(_ pause: Bool) {
        DispatchQueue.main.async {
            self.isPaused = pause
        }
    }
}
