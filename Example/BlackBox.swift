//
//  BlackBox.swift
//  Example
//
//  Created by Michael on 3/26/19.
//  Copyright © 2019 Signal Messenger. All rights reserved.
//

import Foundation

class FakeNetworkService: NetworkService {
    let failureRatio = 0.05

    enum NetworkServiceError: Error {
        case serverDown
    }

    func makeGetNextInputRequest(completion: @escaping (Int?, Error?) -> Void) {
        let randomDelay = TimeInterval.random(in: 0.2..<5.0)

        DispatchQueue.global().asyncAfter(deadline: .now() + randomDelay) {
            if Double.random(in: 0..<1) >= self.failureRatio {
                let nextInput = Int.random(in: 0..<Int.max)
                completion(nextInput, nil)
            } else {
                completion(nil, NetworkServiceError.serverDown)
                return
            }
        }
    }
}

class BlackBox {
    class func process(input: Int) -> Double {
        let remainder = (input % 1000)
        let timeout = UInt32(remainder / 100)
        sleep(timeout)

        return pow(1.01, Double(remainder))
    }
}
