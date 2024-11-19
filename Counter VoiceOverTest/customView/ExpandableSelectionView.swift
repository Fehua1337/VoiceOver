//
//  ExpandableSelectionView.swift
//  Calculator
//
//  Created by Alisher Tulembekov on 12.11.2024.
//
import Foundation
import SnapKit
import UIKit

class ExpandableSelectionView: UIView {
    
    var items: [String]? {
        didSet {
            itemsTableView.reloadData()
        }
    }
    var selectedItem = "" {
        didSet {
            selectedItemLabel.text = selectedItem
        }
    }
    
    var color: UIColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0) { // #F2F3F4
        didSet {
            layoutSubviews()
            self.backgroundColor = color
        }
    }
    
    var leftSideImage: UIImage? {
        didSet {
            leftSideImageView.isHidden = false
            leftSideImageView.image = leftSideImage
        }
    }
    
    var defaultHeight = 40
    
    var id: String?
    var codeName: String?
    private var isExpanded = false
    
    var delegate: ExpandableSelectionDelegate?
    
    lazy var selectItemView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(red: 0.77, green: 0.81, blue: 0.85, alpha: 1.0).cgColor // #C4CEDA
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var selectedItemLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.text = ""
        return label
    }()
    
    lazy var arrowBottomImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "arrow_bottom")
        return image
    }()
    
    lazy var leftSideImageView: UIImageView = {
       let image = UIImageView()
        image.layer.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        image.isHidden = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var selectItemTitleView: UIStackView = {
        let view = UIStackView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCategories)))
        view.axis = .horizontal
        view.spacing = 4
        view.distribution = .equalSpacing
        return view
    }()
    
    lazy var itemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.rowHeight = 40
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.layer.cornerRadius = 8
        self.backgroundColor = color
        self.addSubview(selectItemTitleView)
        self.addSubview(itemsTableView)
        selectItemTitleView.addArrangedSubview(leftSideImageView)
        selectItemTitleView.addArrangedSubview(selectedItemLabel)
        selectItemTitleView.addArrangedSubview(arrowBottomImage)
        setupConstraints()
    }
    
    private func setupConstraints() {
        leftSideImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(12)
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        selectedItemLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        arrowBottomImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview()
            make.height.equalTo(16)
        }
        
        selectItemTitleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        itemsTableView.snp.makeConstraints { make in
            make.top.equalTo(selectItemTitleView.snp.bottom)
            make.height.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func showCategories() {
        if !isExpanded {
            itemsTableView.isHidden = false
            UIView.animate(withDuration: 3.0, delay: 0) {
                let height = 40 * (self.items?.count ?? 0)
                self.itemsTableView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }
                self.snp.updateConstraints { make in
                    make.height.equalTo(height + self.defaultHeight)
                }
            }
        } else {
            itemsTableView.isHidden = true
            UIView.animate(withDuration: 3.0, delay: 0) {
                self.itemsTableView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.snp.updateConstraints { make in
                    make.height.equalTo(self.defaultHeight)
                }
            }
        }
        isExpanded.toggle()
    }
}

extension ExpandableSelectionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = color
        if #available(iOS 14.0, *) {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = items?[indexPath.row]
            cell.contentConfiguration = configuration
        } else {
            cell.textLabel?.text = items?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items?[indexPath.row] ?? ""
        showCategories()
        delegate?.selectionView(selectionView: self, index: indexPath.row)
    }
}

protocol ExpandableSelectionDelegate {
    func selectionView(selectionView: ExpandableSelectionView, index: Int)
}
