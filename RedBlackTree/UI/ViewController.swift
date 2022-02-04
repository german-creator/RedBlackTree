//
//  ViewController.swift
//  RedBlackTree
//
//  Created by Герман Иванилов on 30/12/2021.
//

import UIKit

class ViewController: UIViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()

    let treeView = TreeView()
    let inputNodeView = InputNodeView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        treeView.updateContent()
    }

    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        view.addSubview(inputNodeView)

        scrollView.addSubview(contentView)
        contentView.addSubview(treeView)

        inputNodeView.delegate = self
    }

    private func setConstraints() {
        inputNodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputNodeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputNodeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.smallMargin)
        ])

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])

        let width = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        width.priority = .defaultHigh
        height.priority = .defaultHigh

        NSLayoutConstraint.activate([width, height])

        treeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            treeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            treeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            treeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            treeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension ViewController: InputNodeViewDelegate {
    func didAddNode(with value: Int) {
        let xPosition = inputNodeView.frame.minX + scrollView.bounds.origin.x
        let yPosition = inputNodeView.frame.minY + scrollView.bounds.origin.y - scrollView.frame.minY
        let point = CGPoint(x: xPosition, y: yPosition)

        treeView.addNodeView(with: value, from: point)
    }
}
