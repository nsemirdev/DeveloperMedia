//
//  ViewController.swift
//  DeveloperMedia
//
//  Created by Emir Alkal on 29.12.2022.
//

import UIKit
import Toast
import Photos
import PhotosUI

protocol SignUpInterface where Self: UIViewController {
    func animateTextField(on textField: DMTextField)
    func registrationDidFinishWithError(description: String, style: ToastStyle)
    func registrationDidFinishWithSuccess()
    func hideToastActivity()
}

final class SignUpVC: BaseAuthVC {

    var viewModel: SignUpViewModelInterface? {
        didSet {
            viewModel?.delegate = self
        }
    }
   
    // MARK: - UI Elements
    
    fileprivate let signUpButton: DMButton = {
        let button = DMButton(title: "Sign Up", cornerRadius: 4)
        button.addTarget(nil, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    fileprivate let leftLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#9999A7FF")
        return label
    }()
    
    fileprivate let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(nil, action: #selector(handleRightButton), for: .touchUpInside)
        return button
    }()
        
    fileprivate lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.addArrangedSubview(leftLabel)
        stackView.addArrangedSubview(rightButton)
        stackView.addArrangedSubview(UIView())
        return stackView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureImageView()
        viewModel = SignUpViewModel()
        setTextFields()
        configureStackView()
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(labelStackView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signUpButton.applyGradient()
    }
    
    // MARK: - Methods
    
    fileprivate func configureImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLogoImageView))
        logoImageView.image = UIImage(named: "upload-image")
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setTextFields() {
        textFields = [
            DMTextField(placeHolder: "Your Name", leftImage: UIImage(named: "person")),
            DMTextField(placeHolder: "Your Email", leftImage: UIImage(named: "mail")),
            DMTextField(placeHolder: "Your Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye"), isSecureTextEntry: true),
            DMTextField(placeHolder: "Confirm Password", leftImage: UIImage(named: "password"), rightImage: UIImage(named: "eye"), isSecureTextEntry: true)
        ]
    }
    
    fileprivate func configureStackView() {
        textFields.forEach { textField in
            stackView.addArrangedSubview(textField)
        }
    }

    fileprivate func presentViewController(to viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        present(viewController, animated: true)
    }
    
    // MARK: - Business Logic

    @objc func handleSignUp() {
        view.hideAllToasts()
        viewModel?.registerRequest(with: textFields)
    }
    
    @objc fileprivate func handleRightButton() {
        presentViewController(to: SignInVC())
    }
    
    @objc fileprivate func handleLogoImageView() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc,animated: true)
    }
}

extension SignUpVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.last?.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] image, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self?.logoImageView.image = image
            }
        })
    }
}

extension SignUpVC: SignUpInterface {
    func registrationDidFinishWithSuccess() {
        view.makeToastActivity(.center)
    }
    
    func hideToastActivity() {
        view.hideToastActivity()
    }
    
    func animateTextField(on textField: DMTextField) {
        textField.animateError()
    }
    
    func registrationDidFinishWithError(description: String, style: ToastStyle) {
        view.makeToast(description, position: .top, style: style)
    }
}
