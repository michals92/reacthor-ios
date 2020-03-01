//
//  ViewController.swift
//  reacthor
//
//  Created by Michal Šimík on 01/03/2020.
//  Copyright © 2020 Michal Šimík. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentButton: UIButton?
    var lastTime: Date = Date()
    var dates: [Date] = []
    let buttonSize = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        initialButton()
    }

    func initialButton(title: String? = nil) {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center

        if let title = title {
            button.setTitle(title, for: .normal)
        } else {
            button.setTitle("PLAY GAME", for: .normal)
        }

        button.sizeToFit()
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)

        view.addSubview(button)
        button.center = view.center

    }

    func addButton() {
        guard dates.count < 10 else {
            currentButton?.removeFromSuperview()
            measureReaction(dates: dates)
            return
        }

        let width = Int(view.frame.size.width)-100
        let height = Int(view.frame.size.height)-100

        let button = UIButton(frame: CGRect(x: Int.random(in: buttonSize..<width), y: Int.random(in: buttonSize..<height), width: buttonSize, height: buttonSize))
        button.layer.cornerRadius = CGFloat(buttonSize/2)

        button.backgroundColor = .green
        button.setTitle("#\(dates.count+1)", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        currentButton = button
        view.addSubview(button)

        let nowTime = Date()
        lastTime = nowTime
        dates.append(nowTime)
    }

    @objc func buttonAction(sender: UIButton!) {
        removeButton()
    }

    @objc func startGame(sender: UIButton!) {
        dates = []
        addButton()
        sender.removeFromSuperview()
    }

    func removeButton() {
        currentButton?.removeFromSuperview()
        currentButton = nil
        addButton()
    }

    func measureReaction(dates: [Date]) {
        var intervals: [Double] = []

        for index in 0...dates.count-2 {
            let date1 = dates[index]
            let date2 = dates[index+1]
            intervals.append(date2.timeIntervalSince(date1))
        }

        let milisecondsAverage = Int(intervals.average() * 1000)
        var record = UserDefaults.standard.integer(forKey: "record")


        if record == 0  || milisecondsAverage < record {
            UserDefaults.standard.set(milisecondsAverage, forKey: "record")
            record = milisecondsAverage
        }

        initialButton(title: "PLAY AGAIN \nAverage \(milisecondsAverage)ms\nRECORD \(record)ms")
       // addLabel(text: "Average \(milisecondsAverage) milliseconds")
    }

    func addLabel(text: String) {
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.sizeToFit()
        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension Sequence where Element: BinaryFloatingPoint {
    func average() -> Element {
        var i: Element = 0
        var total: Element = 0

        for value in self {
            total = total + value
            i += 1
        }

        return total / i
    }
}
