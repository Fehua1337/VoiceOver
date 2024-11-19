//
//  textFieldTitle.swift
//  Counter VoiceOverTest
//
//  Created by Alisher Tulembekov on 19.11.2024.
//

import UIKit
import SnapKit

class TextFieldTitle: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Formula"
        label.textColor = UIColor.gray // Changed to a default gray color
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0).cgColor // Changed to a default UIColor as UIColor.hex does not exist
        view.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.delegate = self
        //accessebility
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(textField)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
    }
}

extension TextFieldTitle: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Разрешить только цифры и одну запятую (или точку)
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        let characterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        // Получаем текущий текст в textField и новый текст после изменения
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Проверяем, что после запятой (или точки) не больше двух цифр
        if let separatorIndex = newText.firstIndex(where: { $0 == "." || $0 == "," }) {
            let indexAfterSeparator = newText.index(after: separatorIndex)
            let decimalPart = newText[indexAfterSeparator...]
            return decimalPart.count <= 2
        }
        
        return true
    }
}
