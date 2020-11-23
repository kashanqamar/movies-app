import UIKit

final class MovieDetailsDisplayViewController: UIViewController {
    
    let movieDetails: MovieDetails
    
    init(movieDetails: MovieDetails) {
        self.movieDetails = movieDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = View()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (view as? View)?.configure(movieDetails: movieDetails)
    }
    
    private class View: UIView {
        
        let scrollView = UIScrollView()
        let backdropImageView = UIImageView()
        let titleLabel = UILabel()
        let taglineLabel = UILabel()
        let overviewLabel = UILabel()
        private lazy var labelStackView = UIStackView(arrangedSubviews: [titleLabel, taglineLabel, overviewLabel])
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        private func commonInit() {
            backgroundColor = .white
            
            backdropImageView.contentMode = .scaleAspectFill
            
            titleLabel.font = .title
            titleLabel.textColor = .white
            titleLabel.shadowColor = .darkText
            titleLabel.shadowOffset = CGSize(width: 1, height: 1)
            titleLabel.numberOfLines = 3
            
            taglineLabel.font = .subtitle
            taglineLabel.textColor = .bodyText
            taglineLabel.numberOfLines = 0
            
            overviewLabel.font = .body
            overviewLabel.textColor = .bodyText
            overviewLabel.numberOfLines = 0
            
            labelStackView.axis = .vertical
            labelStackView.spacing = 24
            
            setupViewsHierarchy()
            setupConstraints()
        }
        
        private func setupViewsHierarchy() {
            addSubview(scrollView)
            scrollView.addSubview(backdropImageView)
            scrollView.addSubview(labelStackView)
        }
        
        private func setupConstraints() {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            backdropImageView.translatesAutoresizingMaskIntoConstraints = false
            labelStackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate(
                [
                    scrollView.topAnchor.constraint(equalTo: topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    
                    backdropImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    backdropImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    backdropImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    backdropImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                    backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: 9 / 16, constant: 0),
                    
                    titleLabel.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -12),
                    
                    labelStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                    labelStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                    labelStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
                ]
            )
            
            layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            preservesSuperviewLayoutMargins = false
        }
        
        func configure(movieDetails: MovieDetails) {
            backdropImageView.dm_setImage(backdropPath: movieDetails.backdropPath)
            
            titleLabel.text = movieDetails.title
            
            taglineLabel.text = movieDetails.tagline
            taglineLabel.isHidden = movieDetails.tagline == nil
            
            overviewLabel.text = movieDetails.overview
        }
    }
    
}

