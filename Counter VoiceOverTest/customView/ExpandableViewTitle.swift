//
//  CustomView.swift
//  Calculator
//
//  Created by Alisher Tulembekov on 12.11.2024.
//

import UIKit


class ExpandableViewTitle: UIView {
    
    var id: String = "" {
        didSet {
            expandableView.id = id
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Formula"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var expandableView: ExpandableSelectionView = {
        let view = ExpandableSelectionView()
        view.color = .white
        view.items = ["sDFSD", "sfsdfsd", "sdgregethry", "ytjhg"]
//        view.delegate = self
        view.selectedItem = NSLocalizedString("Фильтр", comment: "Filter label for the expandable view")
        view.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0).cgColor // #F2F3F4
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.arrowBottomImage.isHidden = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(expandableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        expandableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
}

