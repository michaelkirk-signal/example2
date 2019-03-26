//
//  ViewController.swift
//  Example
//
//  Created by Michael on 3/26/19.
//  Copyright © 2019 Signal Messenger. All rights reserved.
//

import UIKit

protocol NetworkService {
    // calls completion with either an Int on success xor an Error on failure
    func getNextInput(completion: @escaping (Int?, Error?) -> Void)

    // Pretend `makeGetNextInputRequest` is a private implementation detail which
    // you don't have access to. It inserts some random delay before calling the
    // completion handler.
    func makeGetNextInputRequest(completion: @escaping (Int?, Error?) -> Void)
}

extension NetworkService {
    func getNextInput(completion: @escaping (Int?, Error?) -> Void) {
        makeGetNextInputRequest(completion: completion)
    }
}

class ViewController: UIViewController {

    let networkService: NetworkService = FakeNetworkService()
    override func viewDidLoad() {
        super.viewDidLoad()

        doWork()
    }

    func doWork() {
        networkService.getNextInput { input, error in
            if let error = error {
                NSLog("error: \(error)")
                self.doWork()
                return
            }

            guard let input = input else {
                assertionFailure("input was unexpectedly nil")
                self.doWork()
                return
            }

            let startPrime = CACurrentMediaTime()
            let result = BlackBox.process(input: input)
            let finishPrime = CACurrentMediaTime()
            let formattedTime = String(format: "%.2fms", (finishPrime - startPrime) * 1000)
            NSLog("output: \(input) -> \(result) (\(formattedTime))")
            self.doWork()
        }
    }
}

