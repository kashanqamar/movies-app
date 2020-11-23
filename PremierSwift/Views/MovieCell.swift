import UIKit

final class MovieCell: UITableViewCell {
    
    let itemSpacing: CGFloat = 20
    let posterSize = CGSize(width: 100, height: 150)
    
    let coverImage = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let topStackView = UIStackView()
    let containerStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        titleLabel.font = .title
        titleLabel.textColor = .titleText
        titleLabel.numberOfLines = 3
        
        descriptionLabel.font = .body
        descriptionLabel.textColor = .bodyText
        descriptionLabel.numberOfLines = 6
        
        coverImage.contentMode = .scaleAspectFit
        
        topStackView.spacing = itemSpacing
        topStackView.alignment = .top
        
        containerStackView.axis = .vertical
        containerStackView.spacing = itemSpacing
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setupViewsHierarchy()
        setupConstraints()
    }
    
    func setupViewsHierarchy() {
        contentView.addSubview(containerStackView)
        topStackView.dm_addArrangedSubviews(coverImage, titleLabel)
        containerStackView.dm_addArrangedSubviews(topStackView, descriptionLabel)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -10),
            
            coverImage.widthAnchor.constraint(equalToConstant: posterSize.width),
            coverImage.heightAnchor.constraint(equalToConstant: posterSize.height)
            ])
    }
    
    func configure(_ movie: Movie) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview

        coverImage.dm_setImage(posterPath: movie.posterPath)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
