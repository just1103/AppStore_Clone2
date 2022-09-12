//
//  ViewController.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/04.
//

import RxSwift
import RxCocoa
import UIKit

final class LookupViewController: UIViewController {
    
    // MARK: - Properties
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .search
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        return textField
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemRed
        return label
    }()
    private let searchTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        tableView.isUserInteractionEnabled = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 6
        return tableView
    }()
    
    private var viewModel: LookupViewModel!
    private let searchTextDidReturn = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    convenience init(viewModel: LookupViewModel) {
        self.init()
        self.viewModel = viewModel
        configureTabBar()
    }
    
    // ???: 여기서 setup하지 않으면 TabBar가 안생기는 문제
    private func configureTabBar() {
        tabBarItem.title = "테스트"
        tabBarItem.image = UIImage(systemName: "plus")
//        tabBarItem.selectedImage = UIImage(systemName: "plus")
//        tabBarItem.setTitleTextAttributes([.font: Design.tabBarTitleFont], for: .normal)
    }
    
    // MARK: - Lifecycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
//        configureTabBar()  // 해결 안됨
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationTitleDisplayMode()
    }

    // MARK: - Methods
    
    private func configureUI() {
        configureNavigationBar()
        configureSearchTextField()
        configureSearchTableView()
        configureHierarchy()
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchTextField() {
        searchTextField.delegate = self
    }
    
    private func configureSearchTableView() {
        searchTableView.register(cellType: SearchTableCell.self)
        // FIXME: Cell constraints broken
//        searchTableView.estimatedRowHeight = UITableView.automaticDimension
//        searchTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureHierarchy() {
        [searchTextField, descriptionLabel, searchTableView]
            .forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            
            searchTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            searchTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func updateNavigationTitleDisplayMode() {
        navigationItem.largeTitleDisplayMode = .always
    }
    
}

// MARK: - Rx Binding Methods

extension LookupViewController {
    
    private func bind() {
        let input = LookupViewModel.Input(
            searchTextDidReturn: searchTextDidReturn.asObservable(),
            viewWillAppear: self.rx.methodInvoked(#selector(viewWillAppear)).map { _ in }
        )

        guard let output = viewModel?.transform(input) else { return }

        output.tabBarItemTitleText
            .drive(tabBarItem.rx.title)
            .disposed(by: disposeBag)

        output.tabBarItemImage
            .drive(tabBarItem.rx.image)
            .disposed(by: disposeBag)

        output.tabBarItemSelectedImage
            .drive(tabBarItem.rx.selectedImage)
            .disposed(by: disposeBag)
        
        output.navigationTitleText
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.backButtonTitleText
            .drive(navigationItem.rx.backButtonTitle)
            .disposed(by: disposeBag)
        
        output.searchTextFieldPlaceHolderText
            .drive(searchTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        output.appItems
            .drive(searchTableView.rx.items(
                cellIdentifier: SearchTableCell.reuseIdentifier,
                cellType: SearchTableCell.self)
            ) { row, appItem, cell in
                cell.apply(appItem: appItem)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - TextFieldDelegate

extension LookupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text else {
            return false
        }
        searchTextDidReturn.onNext(searchText)
        
        return true
    }
    
}
