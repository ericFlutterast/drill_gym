import UIKit

class CreateWorkoutViewController: UIViewController{
    //MARK: FIELDS
    private enum CellIdentifier: String{
        case exersiceCreated
        case exersiceCreating
    }
    
    private var calendarStateControlle = CalendarStateController(calendarDataSourse: CalendarDataSourceImpl(dataManager: DataManger.shared))
    private var tableViewState: [ExerciseModel?] = []
    private var keyboardIsOpen: Bool = false
    private var date: DateComponents?
    
    var selectedDate: DateComponents?{
        get{date}
        set{
            guard newValue != date else {return}
            date = newValue
        }
    }
    
    //MARK: VIEWS
    private lazy var saveButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Save", comment: "save"), for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.systemYellow.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.addTarget(self, action: #selector(saveWorkout), for: .touchUpInside)
        return button
    }()
    
    private lazy var workoutNameTextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray2
        textField.attributedPlaceholder = NSAttributedString(string: "Workout name")
        textField.keyboardType = .default
        textField.textColor = .white
        textField.tintColor = .systemYellow
        textField.layer.cornerRadius = 12
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 10, height: 5))
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.delegate = self
        return textField
    }()
    
    private lazy var addExercisesButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Add exercise", comment: "add exercise"), for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        button.tintColor = .systemYellow
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(addExercise), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExerciseCreatingCell.self, forCellReuseIdentifier: CellIdentifier.exersiceCreating.rawValue)
        tableView.register(ExerciseCreatedCell.self, forCellReuseIdentifier: CellIdentifier.exersiceCreated.rawValue)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentSize = .init(width: view.bounds.height, height: 400)
        tableView.allowsSelection = false
        return tableView
    }()
    
    private func title(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = NSLocalizedString(text, comment: "add workout name")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        return label
    }
    
    private lazy var vStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .leading
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        configurateNavigationItem()
        configurateUI()
        closeKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    private func configurateNavigationItem() {
        navigationItem.title = NSLocalizedString("Create workout", comment: "сreate workout")
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemYellow
    }
    
    @objc private func willShowKeyboard(notification: NSNotification) {
        if keyboardIsOpen {return}
        keyboardIsOpen = true
        
        guard let userInfo = notification.userInfo,
              //Информация о лейауте клавиатуры
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else{return}

        //координаты текстового поля относительно супервью
        let autocompliteKeyboardHeight = CGFloat(50)
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldbottomY = convertedTextFieldFrame.origin.y + (convertedTextFieldFrame.size.height * 3)
        let keyboardYWithoutHeight = keyboardFrame.origin.y - keyboardFrame.size.height - autocompliteKeyboardHeight
        
        if textFieldbottomY >  keyboardYWithoutHeight {
            let deltaY = textFieldbottomY - keyboardYWithoutHeight
            view.frame.origin.y = deltaY * -1
        }
    }
    
    @objc private func willHideKeyboard(notification: NSNotification) {
        keyboardIsOpen = false
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: BUTTON HANDLERS
    @objc private func backButton() {
        
        guard let navigationController = navigationController else{return}
        navigationController.popViewController(animated: true)
    }
    
    @objc private func saveWorkout() {
        print("Workout name: \(workoutNameTextField.text ?? "")")
        print(tableViewState)
        print(date!)
        
        let exercises = tableViewState.compactMap{ $0 }
        let currentDate = Calendar.current.date(from: date!)
        let workout = WorkoutModel(
            name: workoutNameTextField.text ?? "",
            exercises: exercises,
            date: currentDate!
        )
        calendarStateControlle.addEvent(event: .createWorkout(workout))
        
        guard let navigationController = navigationController else {return}
        navigationController.popToRootViewController(animated: true)
    }
    
    @IBAction private func addExercise() {
        tableViewState.append(nil)
        tableView.insertRows(at: [IndexPath(row: tableViewState.count - 1, section: 0)], with: .left)
    }
    
    //MARK: CONSTRAINST
    private func configurateUI() {
        let workoutNameTitle = title(text: "Add workout name")
        let addExercisesTitle = title(text: "Add exercises")
        
        vStack.addArrangedSubview(workoutNameTitle)
        vStack.addArrangedSubview(workoutNameTextField)
        vStack.addArrangedSubview(addExercisesTitle)
        vStack.addArrangedSubview(addExercisesButton)
        
        view.addSubview(vStack)
        view.addSubview(tableView)
        view.addSubview(saveButton)
       
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            workoutNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

//MARK: TABLE VIEW EXTENSION
extension CreateWorkoutViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewState.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableViewState.count{
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: self.view.frame.width, bottom: 0, right: 0)
            cell.layoutMargins = .zero
            return cell
        }
        
        return tableViewState[indexPath.row] != nil ?
        makeCreatedWorkoutCell(indexPath) :
        makeCreatingWorkoutCell(tableView: tableView, indexPath: indexPath)
    }
    
    private func makeCreatedWorkoutCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = ExerciseCreatedCell()
        guard let model = tableViewState[indexPath.row] else {return cell}
        let weight = model.weight != nil ? " - \(model.weight ?? 0) Kg" : ""
        cell.setName(name:
                        " —   \(model.exerciseName): \(model.approaches) X \(model.repeats)\(weight)")
        return cell
    }
    
    private func makeCreatingWorkoutCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        let cell = ExerciseCreatingCell();
        cell.onSave = {(name, approaches, repeats, weight) in
            self.tableViewState[indexPath.row] = ExerciseModel(
                exerciseName: name,
                approaches:  approaches,
                repeats: repeats,
                weight: weight)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
        }
        return cell
    }
}

extension CreateWorkoutViewController: UITableViewDelegate{
    func tableView(_: UITableView, indentationLevelForRowAt: IndexPath) -> Int{
        0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == tableViewState.count ? CGFloat(150) : CGFloat(60)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == tableViewState.count {return UISwipeActionsConfiguration.init(actions: [])}
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, success) in
            self.tableViewState.remove(at: indexPath.row)
            //self.creatingCells.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            success(true)
        }
        
        return UISwipeActionsConfiguration.init(actions: [action])
    }
}

