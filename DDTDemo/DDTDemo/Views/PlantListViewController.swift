//
//  PlantListViewController.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/28.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

class PlantListViewController: BaseViewController {
    // MARK: - Properties
    // UI
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    let navigationView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    let maskView1: UIView = {
        let view = UIView(frame: .zero)
        view.alpha = 0.5
        return view
    }()
    
    let maskView2: UIView = {
        let view = UIView(frame: .zero)
        view.alpha = 0.5
        return view
    }()
    
    let maskView3: UIView = {
        let view = UIView(frame: .zero)
        view.alpha = 0.5
        return view
    }()
    
    let bankLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "國泰世華銀行"
        label.textColor = .white
        label.alpha = 1
        return label
    }()
    
    lazy var accountSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["臺幣帳戶", "外幣帳戶"])
        segmentedControl.tintColor = .white
        segmentedControl.alpha = 1
        //        segmentedControl.addTarget(self, action: #selector(toggleAccount(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    let moneyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        let money = "123,456,789"
        label.text = "$ \(money)"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 1
        return label
    }()
    
    let accountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        let accountDescription = "臺幣"
        let money = "123,456,789"
        label.text = "\(accountDescription) $ \(money)"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClasses: PlantTableViewCell.self)
        tableView.estimatedRowHeight = 0
        tableView.isHidden = true
        tableView.allowsSelection = false
        return tableView
    }()
    
    let headerViewMaxHeight: CGFloat = 300
    let headerViewMinHeight: CGFloat = 66 + UIApplication.shared.statusBarFrame.height
    
    var navigationViewHeightConstraint: NSLayoutConstraint!
    
    var alpha1: CGFloat = 1.0   // bankLabel, accountSegmentedControl, moneyLabel
    var alpha2: CGFloat = 0.0   // accountLabel
    
    let cellMinHeight: CGFloat = 88.0 + .defaultMargin + .defaultMargin
    
    // ViewModel
    var plantListViewModel = PlantListViewModel()
    var plantsOffset = 0

    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        maskView1.addGradientLayer(with: navigationView.bounds, colors: [UIColor.init(hex: "#179845"), UIColor.init(hex: "#CBF8CA")])
        maskView2.addGradientLayer(with: navigationView.bounds, colors: [UIColor.init(hex: "#179845"), UIColor.init(hex: "#85CE7A")])
        maskView3.addGradientLayer(with: navigationView.bounds, colors: [UIColor.init(hex: "#179845"), UIColor.init(hex: "#85CE7A")])
    }
    
    // MARK: - Inherit method
    override func setupBaseUI() {
        super.setupBaseUI()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        activityIndicatorView.startAnimating()
        
        view.addSubview(navigationView)
        navigationView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        navigationViewHeightConstraint = navigationView.heightAnchor.constraint(equalToConstant: 300)
        navigationViewHeightConstraint.isActive = true
        
        navigationView.addSubview(maskView1)
        navigationView.addSubview(maskView2)
        navigationView.addSubview(maskView3)
        [maskView1, maskView2, maskView3].forEach {
            $0.anchor(top: nil, leading: navigationView.leadingAnchor, bottom: navigationView.bottomAnchor, trailing: navigationView.trailingAnchor, size: CGSize(width: 0, height: 300))
        }
        
        navigationView.addSubview(bankLabel)
        bankLabel.translatesAutoresizingMaskIntoConstraints = false
        bankLabel.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 44).isActive = true
        bankLabel.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor).isActive = true
        
        navigationView.addSubview(accountSegmentedControl)
        accountSegmentedControl.anchor(top: bankLabel.bottomAnchor, leading: navigationView.leadingAnchor, bottom: nil, trailing: navigationView.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20))
        
        navigationView.addSubview(moneyLabel)
        moneyLabel.anchor(top: accountSegmentedControl.bottomAnchor, leading: navigationView.leadingAnchor, bottom: nil, trailing: navigationView.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 20, bottom: 0, right: 20))
        
        navigationView.addSubview(accountLabel)
        accountLabel.anchor(top: nil, leading: navigationView.leadingAnchor, bottom: navigationView.bottomAnchor, trailing: navigationView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 40, right: 20))
        
        setupShapeLayer(with: maskView1, leadingY: 275, trailingY: 290, controlPoint1: 240, controlPoint2: 320)
        setupShapeLayer(with: maskView2, leadingY: 265, trailingY: 265, controlPoint1: 340, controlPoint2: 240)
        setupShapeLayer(with: maskView3, leadingY: 290, trailingY: 280, controlPoint1: 240, controlPoint2: 290)
        
        view.addSubview(tableView)
        tableView.anchor(top: navigationView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        plantListViewModel.plantCellViewModels.addObserver(willPerfromImmediately: false) { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isHidden = false
            
            if strongSelf.plantsOffset == 0 {
                strongSelf.tableView.reloadData()
                strongSelf.plantsOffset = strongSelf.plantListViewModel.plantCellViewModels.value.count
            } else {
                let count = strongSelf.plantListViewModel.plantCellViewModels.value.count
                let range = strongSelf.plantsOffset..<count
                let indexPaths = range.map { IndexPath(row: $0, section: 0) }
                strongSelf.tableView.insertRows(at: indexPaths, with: .fade)
                strongSelf.plantsOffset = count
            }
        }
        
        plantListViewModel.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    override func setupData() {
        super.setupData()
       
        plantListViewModel.start()
    }
    
    // MARK: - Private method
    private func setupShapeLayer(with maskView: UIView, leadingY: CGFloat, trailingY: CGFloat, controlPoint1: CGFloat, controlPoint2: CGFloat) {
        let width = view.frame.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: leadingY))
        path.addCurve(to: CGPoint(x: width, y: trailingY),
                      controlPoint1: CGPoint(x: view.frame.size.width / 3, y: controlPoint1),
                      controlPoint2: CGPoint(x: view.frame.size.width / 3 * 2, y: controlPoint2))
        path.addLine(to: CGPoint(x: view.frame.size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        maskView.layer.mask = shapeLayer
    }
    
    private func estimatedHeight(with string: String?) -> CGFloat {
        guard let string = string,
            string != "" else { return 0 }
        let estimatedWidth = view.frame.width - .defaultMargin - 88 - .defaultMargin - .defaultMargin
        let size = CGSize(width: estimatedWidth, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline, compatibleWith: nil)]
        let estimatedFrame = NSString(string: string)
            .boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return estimatedFrame.height + .defaultMargin
    }
}

// MARK: - UITableViewDataSource
extension PlantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantListViewModel.plantCellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plantCellViewModel = plantListViewModel.plantCellViewModels.value[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlantTableViewCell.className, for: indexPath) as? PlantTableViewCell else { return UITableViewCell() }
        cell.setup(viewModel: plantCellViewModel)
        cell.layoutIfNeeded()
        
        if indexPath.row == plantListViewModel.plantCellViewModels.value.count - 5 {
            plantListViewModel.loadMorePlants()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PlantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let platsCellViewModel = plantListViewModel.plantCellViewModels.value[indexPath.row]
        let nameHeight = estimatedHeight(with: platsCellViewModel.name)
        let locationHeight = estimatedHeight(with: platsCellViewModel.location)
        let featureHeight = estimatedHeight(with: platsCellViewModel.feature)
        let estimatedHeight = .defaultMargin + nameHeight + locationHeight + featureHeight
        return (estimatedHeight > cellMinHeight) ? estimatedHeight : cellMinHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if navigationViewHeightConstraint.constant > headerViewMaxHeight / 2 {
            navigationViewHeightConstraint.constant = headerViewMaxHeight
            alpha1 = 1
            alpha2 = 0
        } else {
            navigationViewHeightConstraint.constant = headerViewMinHeight
            alpha1 = 0
            alpha2 = 1
        }
        
        bankLabel.alpha = alpha1
        accountSegmentedControl.alpha = alpha1
        moneyLabel.alpha = alpha1
        accountLabel.alpha = alpha2
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        let newNavigationViewHeight: CGFloat = navigationViewHeightConstraint.constant - y
        
        if newNavigationViewHeight > headerViewMaxHeight {
            navigationViewHeightConstraint.constant = headerViewMaxHeight
        } else if newNavigationViewHeight < headerViewMinHeight {
            navigationViewHeightConstraint.constant = headerViewMinHeight
        } else {
            navigationViewHeightConstraint.constant = newNavigationViewHeight
            scrollView.contentOffset.y = 0
        }
        
        alpha1 = (navigationViewHeightConstraint.constant - headerViewMinHeight) / (headerViewMaxHeight - headerViewMinHeight)
        alpha2 = 1 - ((navigationViewHeightConstraint.constant - headerViewMinHeight) / (headerViewMaxHeight - headerViewMinHeight))
        
        bankLabel.alpha = alpha1
        accountSegmentedControl.alpha = alpha1
        moneyLabel.alpha = alpha1
        accountLabel.alpha = alpha2
    }
}
