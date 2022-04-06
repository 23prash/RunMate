//
//  TimeService.swift
//  RunMate
//
//  Created by Prashant Pukale on 3/6/22.
//

import Foundation
import Combine

protocol TimerProtocol {
    init(frequency: TimeInterval)
    func atTimeInterval() -> AnyPublisher<TimeInterval, Never>
    func start() -> AnyPublisher<TimeInterval, Never>
    func pause(_ pause: Bool)
}

final class RMTimer: TimerProtocol {
    private let timer: Timer.TimerPublisher
    private var disposeBag = Set<AnyCancellable>()
    private var isPaused = true
    private var totalTimeInternal: TimeInterval = 0
    private let frequency: TimeInterval

    private let timerSubject = CurrentValueSubject<TimeInterval, Never>(0)
    init(frequency: TimeInterval = 1) {
        self.frequency = frequency
        timer = Timer.publish(every: frequency,
                              on: .main,
                              in: .common)
    }

    func atTimeInterval() -> AnyPublisher<TimeInterval, Never> {
        return timerSubject.eraseToAnyPublisher()
    }

    @discardableResult
    func start() -> AnyPublisher<TimeInterval, Never> {
        timer.autoconnect()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self,
                      !self.isPaused else { return }
                self.totalTimeInternal += self.frequency
                self.timerSubject.send(self.totalTimeInternal)
            }.store(in: &disposeBag)
        isPaused = false
        return timerSubject.eraseToAnyPublisher()
    }

    func pause(_ pause: Bool) {
        DispatchQueue.main.async {
            self.isPaused = pause
        }
    }
}
