//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Olya on 10.10.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var nicknameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAvatar()
        setupLabels()
        setupLogoutButton()
    }
    
    private func setupAvatar() {
        let avatarImage = UIImage(named: "avatar_pic")
        let imageView = UIImageView(image: avatarImage)
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        avatarImageView = imageView
    }
    
    private func setupLabels() {
        guard let avatarImageView = avatarImageView else { return }
        let name = UILabel()
        name.text = "Екатерина Новикова"
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(name)
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)])
        nameLabel = name
        
        let nickname = UILabel()
        nickname.text = "@ekaterina_nov"
        nickname.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        nickname.font = UIFont.systemFont(ofSize: 13)
        
        nickname.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickname)
        
        NSLayoutConstraint.activate([
            nickname.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            nickname.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
        nicknameLabel = nickname
        
        let description = UILabel()
        description.text = "Hello, world!"
        description.textColor = .white
        description.font = UIFont.systemFont(ofSize: 13)
        
        description.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(description)
        
        NSLayoutConstraint.activate([
            description.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 8),
            description.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
        descriptionLabel = description
    }
    
    private func setupLogoutButton() {
        guard let avatarImageView = avatarImageView else { return }
        let image = UIImage(systemName: "ipad.and.arrow.forward")
        let button = UIButton.systemButton(with: image!, target: self, action: #selector(didTapLogoutButton))
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        logoutButton = button
    }
    @objc private func didTapLogoutButton() {
    }
}
