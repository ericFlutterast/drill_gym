import UIKit

class AddWorkoutOnCalendarViewController: UIViewController{
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        configurateNavigationItem()
        view.addSubview(collectionView)
        configurateScrollView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configurateNavigationItem(){
        guard let navigationController = navigationController else {
            return
        }
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.sizeToFit()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.barTintColor = .systemGray
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemYellow]

        navigationItem.title = NSLocalizedString("Add workout", comment: "add workout")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(createWorkout))
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemYellow
    }
    
    private func configurateScrollView() {
        collectionView.backgroundColor = .systemGray
        collectionView.register(WorkoutCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc private func createWorkout() {
        guard let navigationController = navigationController else{return}
        
        self.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(CreateWorkoutViewController(), animated: true)
    }
    
    @objc private func backButton() {
        guard let navigationController = navigationController else{return}
        navigationController.popViewController(animated: true)
    }
}

extension AddWorkoutOnCalendarViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        guard let cell = cell as? WorkoutCell else {
            return cell
        }
        
        return cell
    }
}

extension AddWorkoutOnCalendarViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension AddWorkoutOnCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        .init(width: collectionView.bounds.width, height: 200)
    }
}

private final class WorkoutCell: UICollectionViewCell{
    private lazy var divider = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        return view
    }()
    
    private lazy var title = {
        let lable = UILabel()
        lable.text = NSLocalizedString("Workout if back", comment: "workout if back")
        lable.textColor = .white
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .left
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return lable
    }()
    
    private lazy var vStack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        addSubview(title)
        addSubview(divider)
        
        let exercises = vStack
        
        for _ in 0...4 {
            let label = UILabel()
            label.text = "· Push ups: 3 X 10"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            exercises.addArrangedSubview(label)
        }
        addSubview(exercises)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            title.heightAnchor.constraint(equalToConstant: 24),
            
            exercises.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            exercises.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            exercises.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            exercises.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        divider.frame = .init(x: 0, y: contentView.bounds.height, width: contentView.bounds.width, height: 1)
    }
}

private class WorkoutCellContent: UIView{
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
}


