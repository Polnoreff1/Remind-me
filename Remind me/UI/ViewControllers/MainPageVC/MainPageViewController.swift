//
//  MainPageViewController.swift
//  Remind me
//
//  Created by Andrey Versta on 16.05.2022.
//

import UIKit

class MainPageViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var welcomeView: UIView!
    @IBOutlet private weak var countTasksLabel: UILabel!
    @IBOutlet private weak var countTasksView: UIView!
    @IBOutlet private weak var tasksListButton: UIButton!
    
    // MARK: - Properties
    
    private let viewModel: IMainPageViewModel
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    init(viewModel: IMainPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func bindViewModel() {
        viewModel.tasksCount.bind { (taskCount) in
            DispatchQueue.main.async { [weak self] in
                self?.countTasksLabel.text = String(taskCount)
            }
        }
        viewModel.getTasksCount()
    }
    
    private func setupViews() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tasksListButton.layer.cornerRadius = 15
        setupWelcomeView()
        setupCountTasksView()
    }
    
    private func setupWelcomeView() {
        welcomeView.frame = CGRect(
            x: 0,
            y: 0,
            width: 335,
            height: 130
        )
        welcomeView.backgroundColor = .clear
        let shadows = UIView()
        shadows.frame = welcomeView.frame
        shadows.clipsToBounds = false
        welcomeView.addSubview(shadows)
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 20)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(
            red: 0.208,
            green: 0.216,
            blue: 0.243,
            alpha: 1
        ).cgColor
        layer0.shadowOpacity = 10
        layer0.shadowRadius = 30
        layer0.shadowOffset = CGSize(width: 10, height: 10)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
        let shadowPath1 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 20)
        let layer1 = CALayer()
        layer1.shadowPath = shadowPath1.cgPath
        layer1.shadowColor = UIColor(
            red: 0.979,
            green: 0.983,
            blue: 1,
            alpha: 0.4
        ).cgColor
        layer1.shadowOpacity = 10
        layer1.shadowRadius = 30
        layer1.shadowOffset = CGSize(width: -10, height: -10)
        layer1.compositingFilter = "softLightBlendMode"
        layer1.bounds = shadows.bounds
        layer1.position = shadows.center
        shadows.layer.addSublayer(layer1)
        let shapes = UIView()
        shapes.frame = welcomeView.frame
        shapes.clipsToBounds = true
        welcomeView.addSubview(shapes)
        let layer2 = CALayer()
        layer2.backgroundColor = UIColor(
            red: 0.306,
            green: 0.333,
            blue: 0.365,
            alpha: 1
        ).cgColor
        layer2.bounds = shapes.bounds
        layer2.position = shapes.center
        shapes.layer.addSublayer(layer2)
        let layer3 = CAGradientLayer()
        layer3.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        ]
        layer3.locations = [0, 1]
        layer3.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer3.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer3.transform = CATransform3DMakeAffineTransform(CGAffineTransform(
            a: -1.62,
            b: -1.45,
            c: 1.45,
            d: -1.62,
            tx: 0.54,
            ty: 1.98
        ))
        layer3.compositingFilter = "softLightBlendMode"
        layer3.bounds = shapes.bounds.insetBy(
            dx: -0.5*shapes.bounds.size.width,
            dy: -0.5*shapes.bounds.size.height
        )
        layer3.position = shapes.center
        shapes.layer.addSublayer(layer3)
        shapes.layer.cornerRadius = 20
        welcomeView.addSubview(welcomeLabel)
        welcomeLabel.text = "Welcome"
    }
    
    private func setupCountTasksView() {
        countTasksView.layer.cornerRadius = countTasksView.bounds.width / 2
    }
    
    // MARK: - IBActions
    
    @IBAction func showScreenWithTasks(_ sender: UIButton) {
        viewModel.showTasksScreen(from: self)
    }
}
