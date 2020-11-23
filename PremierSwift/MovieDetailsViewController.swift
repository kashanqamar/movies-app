import UIKit

final class MovieDetailsViewController: UIViewController {
    
    
    let movie: Movie
    var movieDetails: MovieDetails?
    var similarMovies: SimilarMovies?
    var currentViewController: UIViewController!
    let label = UILabel(frame: CGRect(x: 100, y: 200, width: UIScreen.main.bounds.width, height: 50))
    
    
    weak var collectionView: UICollectionView!
    var cellId = "Cell"

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let loadingViewController = LoadingViewController()
        addChild(loadingViewController)
        loadingViewController.view.frame = view.bounds
        loadingViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(loadingViewController.view)
        loadingViewController.didMove(toParent: self)
        currentViewController = loadingViewController
                
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
                
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            
        ])
        self.collectionView = collectionView
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .white
        self.collectionView.showsVerticalScrollIndicator = false
        
        //label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchDataForRelatedMovies()
        self.label.text = "Similar Movies"
    }
    
    
    @objc func fetchDataForRelatedMovies() {
        APIManager.shared.execute(SimilarMovies.details(for: movie)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let similarMovies):
                DispatchQueue.main.async {                    
                    self.similarMovies = similarMovies
                    self.collectionView.reloadData()
                }
            case .failure:
                DispatchQueue.main.async {
                    self.showError()
                }
            }
        }
    }
    
    
    
    @objc func fetchData() {
        APIManager.shared.execute(MovieDetails.details(for: movie)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieDetails):
                DispatchQueue.main.async {
                    self.showMovieDetails(movieDetails)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.showError()
                }
            }
        }
    }
    
    func showMovieDetails(_ movieDetails: MovieDetails) {
        let displayViewController = MovieDetailsDisplayViewController(movieDetails: movieDetails)
        addChild(displayViewController)
        displayViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 450)
        displayViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        currentViewController.willMove(toParent: nil)
        transition(
            from: currentViewController,
            to: displayViewController,
            duration: 0.25,
            options: [.transitionCrossDissolve],
            animations: nil
        ) { (_) in
            self.currentViewController.removeFromParent()
            self.currentViewController = displayViewController
            self.currentViewController.didMove(toParent: self)
        }
    }
    
    func showError() {
        let alertController = UIAlertController(title: "", message: LocalizedString(key: "moviedetails.load.error.body"), preferredStyle: .alert)
        let alertAction = UIAlertAction(title: LocalizedString(key: "moviedetails.load.error.actionButton"), style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}


class CollectionCell: UICollectionViewCell {
    var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: Helper
extension CollectionCell {
    fileprivate func setup() {
        imageView.frame = CGRect(x: 0, y: 350, width: 100, height: 200)
        self.addSubview(imageView)
    }
}


extension MovieDetailsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.similarMovies?.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionCell
        cell.imageView.dm_setImage(posterPath: self.similarMovies?.results[indexPath.row].backdrop_path ?? "") //= UIImage.init(named: "dog.png")
        return cell
    }
}


extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 380)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0.0
    }
}
