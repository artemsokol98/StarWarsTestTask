//
//  TableViewCell.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 14.12.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "StarWarsFilmsIdentifier"
    
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
        contentView.addSubview(nameFilmLabel)
        contentView.addSubview(nameDirectorLabel)
        contentView.addSubview(nameProducerLabel)
        contentView.addSubview(yearReleaseLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configureCell(data: FilmsTableViewCellModel) {
        self.nameFilmLabel.text = data.FilmName
        self.nameDirectorLabel.text = data.DirectorName
        self.nameProducerLabel.text = data.ProducerName
        self.yearReleaseLabel.text = data.YearRelease
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
