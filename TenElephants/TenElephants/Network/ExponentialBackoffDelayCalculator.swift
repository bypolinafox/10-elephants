//
//  RequestDelayCounter.swift
//  Ten Elephants
//
//  Created by Полина Скалкина on 15.12.2021.
//

final class ExponentialBackoffDelayCalculator {
    // seconds
    private let maxDelay: Double
    private let minDelay: Double
    private let jitter: Double
    private let factor: Double

    private var currentDelay: Double

    init(
        currentDelay: Double = 0.1,
        minDelay: Double = 0.1,
        maxDelay: Double = 15,
        jitter: Double = 0.1,
        factor: Double = 2.0
    ) {
        self.currentDelay = currentDelay
        self.minDelay = minDelay
        self.maxDelay = maxDelay
        self.jitter = jitter
        self.factor = factor
    }

    func countDelay() -> Double {
        currentDelay *= factor
        currentDelay += Double.random(in: 0.0...(currentDelay * jitter))
        return min(currentDelay, maxDelay)
    }

    func resetDelay() {
        currentDelay = minDelay
    }
}
