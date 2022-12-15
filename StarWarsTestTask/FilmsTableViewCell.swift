//
//  TableViewCell.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 14.12.2022.
//

import UIKit

class FilmsTableViewCell: UITableViewCell {
    
    static let identifier = "StarWarsFilmsIdentifier"
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(nameFilmLabel)
        stackView.addArrangedSubview(nameDirectorLabel)
        stackView.addArrangedSubview(nameProducerLabel)
        stackView.addArrangedSubview(yearReleaseLabel)
        return stackView
    }()
    
    
    private lazy var nameFilmLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var nameDirectorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var nameProducerLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var yearReleaseLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /*
        contentView.addSubview(nameFilmLabel)
        contentView.addSubview(nameDirectorLabel)
        contentView.addSubview(nameProducerLabel)
        contentView.addSubview(yearReleaseLabel)
         */
        contentView.addSubview(verticalStackView)
        contentView.layer.cornerRadius = 10//contentView.bounds.width * 0.2
        contentView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
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
    
    func configureCell(data: FilmsTableViewCellModel) {
        self.nameFilmLabel.text = data.FilmName
        self.nameDirectorLabel.text = data.DirectorName
        self.nameProducerLabel.text = data.ProducerName
        self.yearReleaseLabel.text = data.YearRelease
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
