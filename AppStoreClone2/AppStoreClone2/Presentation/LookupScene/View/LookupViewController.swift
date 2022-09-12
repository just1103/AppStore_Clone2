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
//        tableView.separatorInset.left = 0
        return tableView
    }()
    
    private var viewModel: LookupViewModel!
    private let searchTextDidReturn = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    convenience init(viewModel: LookupViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        clearDescriptionLabel()
        updateNavigationTitleDisplayMode()
    }

    // MARK: - Methods
    
    private func configureUI() {
        configureNavigationBar()
        configureSearchTextField()
        configureHierarchy()
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchTextField() {
        searchTextField.delegate = self
    }
    
    private func configureHierarchy() {
        view.addSubview(searchTextField)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
        ])
    }
    
//    private func clearDescriptionLabel() {
//        descriptionLabel.text = ""  // TODO: ViewWillAppear event와 연결
//    }
    
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

        output.navigationTitleText
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.backButtonTitleText
            .drive(navigationItem.rx.backButtonTitle)
            .disposed(by: disposeBag)
        
        output.searchTextFieldPlaceHolderText
            .drive(searchTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        output.descriptionLabelText
            .drive(descriptionLabel.rx.text)
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
