import UIKit
import Combine

final class WorkoutDetailViewController: UIViewController{
    private var exercises: [String] = []
    private var progress: Float = 0.0
    
    private let workoutDetailStateContext: StateContext<WorkoutDetailState, WorkoutDetailEvents>
    private var workoutDetailCancellable: AnyCancellable?
    
    private enum Identifier: String{
        case detailWorkoutCell
        case header
    }
    
    private var date: Date?
    var selectedDate: Date? {
        get { date }
        set {
            guard newValue != date else {return}
            date = newValue
        }
    }
    
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray
        
        return collectionView
    }()
    
    init(workoutDetailStateContext: StateContext<WorkoutDetailState, WorkoutDetailEvents>) {
        self.workoutDetailStateContext = workoutDetailStateContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        workoutDetailCancellable?.cancel()
    }
    
    override func loadView() {
        super.loadView()
        guard let date = date else {
            logger.info("Что то пошло не так")
            return
        }
        workoutDetailStateContext.add(event: .fetchWorkout(date))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        configurateNavBar()
        configurateCollectionView()
        workoutDetailCancellable = workoutDetailStateContext.publisher.sink {state in
            let workoutName = state.workout?.name ?? ""
            self.navigationItem.title = NSLocalizedString(workoutName, comment: workoutName)
            self.exercises = state.workout?.exercisesDesc ?? []
            self.progress = state.workout?.percentProgress ?? 0.0
            self.collectionView.reloadData()
        }
    }
    
    private func configurateNavBar() {
        guard let navigationController = navigationController else { return }
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.sizeToFit()
        navigationController.navigationBar.barTintColor = .systemGray
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
    
        navigationItem.titleView?.tintColor = .yellow
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemYellow
    }
    
    @objc private func backButton() {
        guard let navigationController = navigationController else {return}
        navigationController.popViewController(animated: true)
    }
    
    private func configurateCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(DetailWorkoutCell.self, forCellWithReuseIdentifier: Identifier.detailWorkoutCell.rawValue)
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Identifier.header.rawValue)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: DataSource
extension WorkoutDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.detailWorkoutCell.rawValue, for: indexPath)
        
        guard let cell = reusableCell as? DetailWorkoutCell else {
            return reusableCell
        }
        cell.setTitle(string: self.exercises[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: Identifier.header.rawValue,
                for: indexPath)
            
            header.backgroundColor = .systemGray
            let label = UILabel(frame: .init(x: view.bounds.width / 2 - 100, y: 0, width: 200, height: 30))
            label.text = "Progress: \(progress) %"
            label.textColor = .white
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20, weight: .bold)
            header.addSubview(label)
            return header
        }
        
        return UICollectionReusableView()
    }
}


extension WorkoutDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: view.bounds.width, height: 40)
    }
}

final class DetailWorkoutCell: UICollectionViewCell{
    lazy var title = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    func setTitle(string: String) {
        title.text = NSLocalizedString(string, comment: string)
    }
}
