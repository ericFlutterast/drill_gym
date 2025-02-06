import UIKit

class AddWorkoutOnCalendarViewController: UIViewController{
    private var date: DateComponents?
    private let calendarStateContext: StateContext<CalendarState, CalendarStateContextEvents>
    
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
    
    var selectedDate: DateComponents?{
        get{date}
        set{
            guard newValue != date else {return}
            date = newValue
        }
    }
    
    init(calendarStateContext: StateContext<CalendarState, CalendarStateContextEvents>) {
                self.calendarStateContext = calendarStateContext
                super.init(nibName: nil, bundle: nil)
            }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = UIView()
        calendarStateContext.add(event: .fetchWorkouts)
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
        guard let createWorkoutViewController = AppNavigation.getRout(path: .createWorkout) as? CreateWorkoutViewController else{return}
        createWorkoutViewController.selectedDate = date
        navigationController.pushViewController(createWorkoutViewController, animated: true)
    }
    
    @objc private func backButton() {
        guard let navigationController = navigationController else{return}
        navigationController.popViewController(animated: true)
    }
}

extension AddWorkoutOnCalendarViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calendarStateContext.state.workouts?.count ?? 0 // Пересмотреть получение данных
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        guard let cell = cell as? WorkoutCell else {
            return cell
        }
        let workoutName = calendarStateContext.state.workouts![indexPath.row].name!
        cell.setName(name: workoutName)
        
        //Пересмотреть парсинг
        let exercises = calendarStateContext.state.workouts![indexPath.row].exercises as? Set<Exercise>
        let exerciseNames = exercises?.compactMap { $0.name }
        cell.setExercises(exerciseNames: exerciseNames ?? [])
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
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            title.heightAnchor.constraint(equalToConstant: 24),
            
            vStack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        divider.frame = .init(x: 0, y: contentView.bounds.height, width: contentView.bounds.width, height: 1)
    }
    
    func setName(name: String){
        title.text = NSLocalizedString(name, comment: name)
    }
    
    func setExercises(exerciseNames: [String]) {
        for name in exerciseNames {
            let label = UILabel()
            label.text = name
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            vStack.addArrangedSubview(label)
        }
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


