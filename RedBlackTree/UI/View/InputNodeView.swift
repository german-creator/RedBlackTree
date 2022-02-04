//
//  InputNodeView.swift
//  RedBlackTree
//
//  Created by Герман Иванилов on 13/01/2022.
//

import UIKit

protocol InputNodeViewDelegate: AnyObject {
    func didAddNode(with value: Int)
}

class InputNodeView: UIView {
    
    private var nodeView = NodeView()
    private let textField = UITextField()

    weak var delegate: InputNodeViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetup()
    }

    func initSetup() {
        setupViews()
        setConstraints()
    }

    private func setupViews() {
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(doneWithNumberPad))]

        toolbar.sizeToFit()

        textField.inputAccessoryView = toolbar
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.attributedPlaceholder = NSAttributedString(
            string: "Add",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.textAlignment = .center

        nodeView.backgroundColor = .gray

        addSubview(nodeView)
        addSubview(textField)
    }

    private func setConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Constants.nodeSize),
            heightAnchor.constraint(equalToConstant: Constants.nodeSize)
        ])

        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 20),
            textField.widthAnchor.constraint(equalToConstant: 50)
        ])

        nodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nodeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nodeView.topAnchor.constraint(equalTo: topAnchor),
            nodeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nodeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func cancelNumberPad() {
        textField.text = nil
        textField.resignFirstResponder()
    }

    @objc private func doneWithNumberPad() {
        guard let text = textField.text,
              let value = Int(text) else { return }

        delegate?.didAddNode(with: value)

        textField.text = nil
        textField.resignFirstResponder()
    }
}
