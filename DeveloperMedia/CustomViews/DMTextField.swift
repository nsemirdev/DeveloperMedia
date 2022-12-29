//
//  DMTextField.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit
import SnapKit

final class DMTextField: UIView {
    
    // MARK: - UI Elements
    
    fileprivate let textField = UITextField()

    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    fileprivate var leftImageView: UIImageView?
    fileprivate var rightImageView: UIImageView?

    // MARK: - Methods
    
    init(placeHolder: String,
         keyboardType: UIKeyboardType = .default,
         leftImage: UIImage? = nil,
         rightImage: UIImage? = nil,
         backgroundColor: UIColor = .clear,
         placeHolderAttributes: NSAttributedString? = nil,
         textAttributes: [NSAttributedString.Key: Any]? = nil,
         isSecureTextEntry: Bool = false,
         cornerRadius: CGFloat = 0) {
        
        super.init(frame: .zero)
        clipsToBounds = true
        self.backgroundColor = backgroundColor
        textField.placeholder = placeHolder
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureTextEntry
        
        if let textAttributes {
            textField.defaultTextAttributes = textAttributes
        }
        if let placeHolderAttributes {
            textField.attributedPlaceholder = placeHolderAttributes
        }
        
        leftImageView = leftImage != nil ? UIImageView(image: leftImage) : nil
        rightImageView = rightImage != nil ? UIImageView(image: rightImage) : nil
        
        configureViews()
        layout()
    }
    
    fileprivate func configureViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(textField)
        configureImageViews()
    }
    
    fileprivate func configureImageViews() {
        if let leftImageView {
            leftImageView.contentMode = .scaleAspectFit
            stackView.insertArrangedSubview(leftImageView, at: 0)
            leftImageView.snp.makeConstraints { make in
                make.width.equalTo(24)
            }
        }
        if let rightImageView {
            rightImageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(rightImageView)
            rightImageView.snp.makeConstraints { make in
                make.width.equalTo(24)
            }
        }
    }
    
    fileprivate func layout() {
        stackView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
