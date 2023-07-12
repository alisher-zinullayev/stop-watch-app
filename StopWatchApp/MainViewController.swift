//
//  ViewController.swift
//  StopWatchApp
//
//  Created by Alisher Zinullayev on 10.07.2023.


import UIKit

class MainViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height

    var timer = Timer()
    var timerForCurrentTime = Timer()
    var startTime: Date?
    var startTimeForCurrentTime: Date?
    var dataHistory: [String] = []

    private let currentTime: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalTime: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()

    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()

    private let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(currentTime)
        view.addSubview(totalTime)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        setupUI()
        view.addSubview(historyTableView)
        historyTableView.delegate = self
        historyTableView.dataSource = self
        configureNavigationBar()
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        historyTableView.frame = CGRect(x: 0, y: screenHeight/2, width: displayWidth, height: displayHeight)
    }

    @objc func leftButtonTapped(sender: UIButton) {
        if leftButton.titleLabel?.text == "Reset" {
            resetButtonTapped()
        } else {
            lapButtonTapped()
        }
    }

    @objc func resetButtonTapped() {
        timer.invalidate()
        currentTime.text = "00:00.00"
        totalTime.text = "00:00.00"
        leftButton.setTitle("Lap", for: .normal)
        rightButton.setTitle("Start", for: .normal)
        dataHistory.removeAll()
        historyTableView.reloadData()
        print("reset button tapped")
    }

    @objc func lapButtonTapped() {
        timerForCurrentTime.invalidate()
//        currentTime.text = "00:00.00"
        dataHistory.append(totalTime.text ?? "")
        historyTableView.reloadData()
        startTimer()
        print("lap button tapped")
    }

    @objc func rightButtonTapped() {
        if rightButton.titleLabel?.text == "Start" {
            startButtonTapped()
        } else {
            stopButtonTapped()
        }
    }

    @objc func startTimer() {
        if !timerForCurrentTime.isValid {
            startTimeForCurrentTime = Date()
            timerForCurrentTime = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate2), userInfo: nil, repeats: true)
            print("lap start button tapped")
        }
    }
    
    @objc func startButtonTapped() {
        
        if !timer.isValid {
            if startTime == nil {
                startTime = Date()
            } else {
                let totalTimeComponents = totalTime.text?.components(separatedBy: ":")
                let minutes = Int(totalTimeComponents?[0] ?? "00") ?? 0
                let seconds = Int(totalTimeComponents?[1].components(separatedBy: ".").first ?? "00") ?? 0
                let milliseconds = Int(totalTimeComponents?[1].components(separatedBy: ".").last ?? "00") ?? 0
                let timeInterval = TimeInterval(minutes * 60 + seconds) + TimeInterval(milliseconds) / 100
                startTime = Date().addingTimeInterval(-timeInterval)
            }
            
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
            print("start button tapped")
            leftButton.setTitle("Lap", for: .normal)
            rightButton.setTitle("Stop", for: .normal)
        }
        
        if !timerForCurrentTime.isValid {
            if startTimeForCurrentTime == nil {
                startTimeForCurrentTime = Date()
            } else {
                let totalTimeComponents = currentTime.text?.components(separatedBy: ":")
                let minutes = Int(totalTimeComponents?[0] ?? "00") ?? 0
                let seconds = Int(totalTimeComponents?[1].components(separatedBy: ".").first ?? "00") ?? 0
                let milliseconds = Int(totalTimeComponents?[1].components(separatedBy: ".").last ?? "00") ?? 0
                let timeInterval = TimeInterval(minutes * 60 + seconds) + TimeInterval(milliseconds) / 100
                startTimeForCurrentTime = Date().addingTimeInterval(-timeInterval)
            }
            
            timerForCurrentTime = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate2), userInfo: nil, repeats: true)
            print("start button tapped")
            leftButton.setTitle("Lap", for: .normal)
            rightButton.setTitle("Stop", for: .normal)
        }
    }

    @objc func stopButtonTapped() {
        timer.invalidate()
        timerForCurrentTime.invalidate()
        leftButton.setTitle("Reset", for: .normal)
        rightButton.setTitle("Start", for: .normal)
        print("stop button tapped")
    }

    @objc func timerUpdate() {
        guard let startTime = startTime else {
            return
        }
        let currentTime = Date().timeIntervalSince(startTime)
        let minutes = Int(currentTime / 60)
        let seconds = Int(currentTime) % 60
        let milliseconds = Int(currentTime * 100) % 100

        self.totalTime.text = String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }

    @objc func timerUpdate2() {
        guard let startTime = startTimeForCurrentTime else {
            return
        }
        let currentTime = Date().timeIntervalSince(startTime)
        let minutes = Int(currentTime / 60)
        let seconds = Int(currentTime) % 60
        let milliseconds = Int(currentTime * 100) % 100

        self.currentTime.text = String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reversedIndexPath = IndexPath(row: dataHistory.count - 1 - indexPath.row, section: indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: reversedIndexPath)
        cell.textLabel?.text = "Lap \(reversedIndexPath.row+1): \(dataHistory[reversedIndexPath.row])"
        return cell
    }
}

extension MainViewController {
    func configureNavigationBar() {
        navigationItem.title = "StopWatch"
        navigationItem.titleView?.tintColor = .black
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.red
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func setupUI() {
        let totalTimeConstraints = [
            totalTime.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalTime.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(screenHeight/4))
        ]

        let currentTimeConstraints = [
            currentTime.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            currentTime.bottomAnchor.constraint(equalTo: totalTime.topAnchor, constant: -3)
        ]

        let leftButtonConstraints = [
            leftButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -screenWidth/7),
            leftButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(screenHeight/4)+130)
        ]

        let rightButtonConstraints = [
            rightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: screenWidth/7),
            rightButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(screenHeight/4)+130)
        ]

        NSLayoutConstraint.activate(totalTimeConstraints)
        NSLayoutConstraint.activate(currentTimeConstraints)
        NSLayoutConstraint.activate(leftButtonConstraints)
        NSLayoutConstraint.activate(rightButtonConstraints)
    }
}
