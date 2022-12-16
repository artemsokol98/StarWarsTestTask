//
//  PersonTableViewCell.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    static let identifier = "StarWarsPersonsIdentifier"
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(namePerson)
        stackView.addArrangedSubview(sexPerson)
        stackView.addArrangedSubview(bornDatePerson)
        return stackView
    }()
    
    private lazy var namePerson: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var sexPerson: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var bornDatePerson: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(verticalStackView)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(red: 0.7, green: 0.5, blue: 0.5, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        verticalStackView.frame = contentView.bounds
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fillEqually
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            verticalStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureCell(data: PersonTableViewCellModel) {
        self.namePerson.text = data.namePerson
        self.sexPerson.text = data.sexPerson
        self.bornDatePerson.text = data.bornDatePerson
    }
    
    
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     */
}
