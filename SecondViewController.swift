//
//  SecondViewController.swift
//  VeganApp
//
//  Created by Luis Gonzalez on 8/3/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

// this is the main color for this app
//#AEE120

import UIKit

struct rootList: Decodable
{
    var foods : [listFood];
}
struct listFood: Decodable
{
    var food: itemListData;
}
struct itemListData: Decodable
{
    var sr : String;
    var ing : itemData;
}
struct itemData : Decodable
{
    var desc: String;
}
// Second Parse
struct dataList: Decodable
{
    var list:groupData?;
    var errors:errorGroup?
}

struct groupData:Decodable
{
    var ds: String?
    var item: [barcodeData];
}

struct barcodeData: Decodable
{
    var group: String?
    var manu: String?
    var name: String?
    var ndbno:String?
}

struct errorGroup: Decodable
{
    var error: [requestStat];
}
struct requestStat: Decodable
{
    var status: Int;
}

class SecondViewController: UIViewController {
    
    final var API_KEY = "JdouFHJpeLxr1HG8LhHyfRdMEnYp4B9mzXYxrYyI";
    final var firstLink = "https://api.nal.usda.gov/ndb/search/?format=json&q=";
    final var endOfLink = "&sort=n&max=5&offset=0&api_key=JdouFHJpeLxr1HG8LhHyfRdMEnYp4B9mzXYxrYyI";
    
    final var secondLink = "https://api.nal.usda.gov/ndb/V2/reports?ndbno="
    final var secondEndLink = "&type=b&format=json&api_key=JdouFHJpeLxr1HG8LhHyfRdMEnYp4B9mzXYxrYyI"
    
    final var completedBoolS: String = "Success";
    final var completdBoolF: String = "Failure";
    public var ingredientStack = [String]();
    
    public var petaStack = [String]();
    let colorPINK: String = "#E1204D";
    let colorGREEN: String = "#8CB618";
    let colorBLUE: String = "#20AEE1";
    let colorWHITE: String = "#ffffff";
    let colorLIGHT_GRAY: String = "#919191";

    
    public var barcode:String = "";
    // new
    public var yPosition:CGFloat = 0;
    public var scrollViewSizeContent: CGFloat = 0;
    
    var stackView = UIStackView();
    var dietTypesStack = UIStackView();

    lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView();
        scroll.translatesAutoresizingMaskIntoConstraints = false;
        scroll.backgroundColor = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 254.0/255.0, alpha: 1.0);
        scroll.isScrollEnabled = true;
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000);
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height);
        return scroll;
    }()
    
    lazy var containerView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 190, height: 180));
        view.backgroundColor = hexStringToUIColor(hex: "#E1204D");
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor;
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
        
    }();
    
    lazy var ingredientText: UITextView = {
        let text = UITextView();
        text.isEditable = false;
        text.isScrollEnabled = true;
        text.scrollsToTop = true;
        text.layer.cornerRadius = 5;
        text.layer.masksToBounds = true;
        text.textColor = UIColor.white;
        text.translatesAutoresizingMaskIntoConstraints = false;
        text.backgroundColor = hexStringToUIColor(hex: "#20AEE1");
        text.isSelectable = true;
        
        return text;
    }()
    
    lazy var problemText : UITextView = {
        let pText = UITextView();
        pText.backgroundColor = hexStringToUIColor(hex: "#20AEE1");
        pText.isEditable = false;
        pText.scrollsToTop = true;
        pText.layer.masksToBounds = true;
        pText.translatesAutoresizingMaskIntoConstraints = false;
        pText.isSelectable = true;
        pText.textColor = UIColor.white;
        pText.layer.cornerRadius = 5;
        return pText;
    }()
    
    
    lazy var scrollViewContainer : UIView = {
        let view = UIView();
        view.backgroundColor = UIColor.lightGray;
        view.frame = CGRect(x: 50, y: 0, width: UIScreen.main.bounds.width, height: 200);
        view.layer.cornerRadius = 5;
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
    }()
    
    lazy var scrollViewInnerContainer : UIScrollView = {
        let scroll = UIScrollView();
        scroll.translatesAutoresizingMaskIntoConstraints = false;
        scroll.isScrollEnabled = true;
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height);
        return scroll;
    }()
    //new
    public var progressCircle = ProgressHUD(text: "Generating..");
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad();
        toolbarConstraints();
        fillStackPeta();
        self.view.addSubview(scrollView); // main scrollView
        c_scrollView();
        self.scrollView.addSubview(imageView) // imageView anchored to top of View.
        c_image();
        self.scrollView.addSubview(containerView); // UIView anchored to top-Right
        c_view();
        self.scrollView.addSubview(ingredientText); // UITextView anchored below UIView Container View
        c_text();
       
        self.scrollView.addSubview(ingredientLabel); // UILabel anchored to obove UITexview ingredientText
        c_label();
        self.scrollView.addSubview(problemText); // UITextView anchored below UITextView ingredientText
        c_problem();
        self.scrollView.addSubview(problemLabel); // UILabel anchored above ProblemText
        c_problemLabel();
        
        
        self.containerView.addSubview(stackView); // stack of item data inner to UIView Container anchored top-right
        stackViewConstraints() // stackView constraints to the bottom left
        c_stackView();
        self.scrollView.addSubview(horizontalLine); //UIView simple line divider
        c_line();
        self.scrollView.addSubview(scrollViewContainer); // horizontal scrollview container <->
        c_scrollViewContainer();
        //
        self.scrollViewContainer.addSubview(scrollViewInnerContainer); // adding scrollView to entire UIView horizontal anchored to entire UIView
        c_scrollViewInnerContainer();
        
        // the purpose of this stack is to add UIViews of information on the different types of diest types.
        // to each box containes the key inportant feature of being pesc, veg, etc.
        //
        self.scrollViewInnerContainer.addSubview(dietTypesStack);
        dietTypesConstaints();
        
        self.view.addSubview(progressCircle);
        attemptGet();
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private func toolbarConstraints()
    {
        self.navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: colorWHITE);
        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: colorGREEN);
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.hidesBarsOnSwipe = true;
    }
    
    public func attemptSecondAPI()
    {
        
        let secondAtt = secondApiAttempt(userBarcode: barcode);
        secondAtt.attemptGet();
        let name = secondAtt.name_data;
        let barcode = secondAtt.barcode_data;
        let ingredient = secondAtt.ingredient_data;
        let brand = secondAtt.brand_data;

        addToStack(ingredient: ingredient);
        
        DispatchQueue.main.async {
            self.ingredientText.text = ingredient;
            self.containerName.text = name;
            self.barcodeLabel.text = barcode;
            self.containerSuccess.text = self.completedBoolS
            self.containerCompanyName.text = brand;
            
            self.progressCircle.removeFromSuperview();
            if(self.attemptSearch()){return ;}
            else {self.returnHome();}
            
        }
        
    }
    
    
    public func addContainerImage(instancesCount : Int)
    {
        let imageView = UIImageView();
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.heightAnchor.constraint(equalToConstant: containerView.frame.size.height / 1.7).isActive = true;
        imageView.contentMode = .center;
        if (instancesCount <= 0)
            
        {
            imageView.image = UIImage(named: "ok");
            containerView.addSubview(imageView);
            imageView.anchorView(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: stackView.topAnchor, trailing: containerView.trailingAnchor);
            
        }
        else if(instancesCount <= 3)
        {
            imageView.image = UIImage(named: "question");
            containerView.addSubview(imageView);
            imageView.anchorView(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: stackView.topAnchor, trailing: containerView.trailingAnchor);
            
        }
        else
        {
            imageView.image = UIImage(named: "error");
            containerView.addSubview(imageView);
            imageView.anchorView(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: stackView.topAnchor, trailing: containerView.trailingAnchor);
        }
        
    
    }

    public func fillStackPeta()
    {
        let path = Bundle.main.path(forResource: "List", ofType: "txt");
        let fileMng = FileManager.default;
        if fileMng.fileExists(atPath: path!)
        {
            do
            {
                let fullText = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8);
                let reading = fullText.components(separatedBy: "\n") as [String];
                for index in 0..<reading.count
                {
                    petaStack.append(reading[index].uppercased());
                }
            }
        }
        else
        {
            print("Error on func", "fillStackPeta()" );
        }
    }

    // if true firstParse is succesful therefore continue to other parse
    // Something is wrong with this function
    // for some reason id doesnt want to return a String;
    public func attemptGet()
    {
        if (barcode.isEmpty)
        {
            print("BARCODE IS EMPTY");
            return ;
        }
        
        guard let m_URL = URL(string: firstLink+barcode+endOfLink) else {return  ;}
       
        let session = URLSession.shared;
        session.dataTask(with: m_URL)
        { (data, response, error) in

            if let response = response as? HTTPURLResponse, response.statusCode != 200
            {
                print("response",response);
                self.progressCircle.removeFromSuperview();
                
                return;
            }
            if let data = data
            {
                do
                {
                    let jsonData = try JSONDecoder().decode(dataList.self, from: data);
                    self.handleDataFirst(data: jsonData);
        
                }
                catch
                {
                    print(error);
                    self.returnHome();
                    self.progressCircle.removeFromSuperview();
                    return;
                }
            }
            if let error = error
            {
                print("Error First Attemp", error.localizedDescription);
                self.dataFailure(error: error.localizedDescription);
                self.progressCircle.removeFromSuperview();
                return;
            }
            
            }.resume();
        return ;
    }

    private func attemptSecondParse(parseValue : String)
    {
        guard let secondUrl = URL(string: secondLink+parseValue+secondEndLink)else {return;}
        let session = URLSession.shared;
        
        session.dataTask(with: secondUrl)
        { (data, response, error) in
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200
            {
                print("response",response);
                session.invalidateAndCancel();
                //self.progressCircle.stopAnimating();
                self.progressCircle.removeFromSuperview();
                return;
            }
            
            if let data = data
            {
                // this is where we contine
                // create a struct model based on SecondParsedAttempt
                // the josn return is ALot Different from the first parse.
                do
                {
                    let secondJsonData = try JSONDecoder().decode(rootList.self, from: data);
                    self.handleSecondParse(data: secondJsonData);
                }
                catch
                {
                    print("Error",error);
                    session.invalidateAndCancel();
                }
            }
            if let error = error
            {
                print("Error Second Attempt", error.localizedDescription);
                self.dataFailure(error: error.localizedDescription)
                return;
            }
        }.resume();
    }
    
    // data faliure for API Calls
    private func dataFailure(error: String)
    {
        DispatchQueue.main.async
            {
                self.progressCircle.removeFromSuperview();
                self.containerName.text = error
                self.containerSuccess.text = self.completdBoolF;
                
                // add action to go home here
                let error = UIAlertController(title: "API Error", message: error, preferredStyle: .alert);
                let action = UIAlertAction(title: "Close", style: .cancel, handler: { (_) in self.navigationController?.popViewController(animated: true)});
                error.addAction(action);
                self.present(error, animated: true, completion: nil);
                
                // attempt to go home;
        }
    }
    
    // Handle the secondParse Attempt
    // Returns home if error is found on secondSearchFunc()
    private func handleSecondParse(data: rootList)
    {
        let dataIngred = data.foods[0].food.ing.desc;
        
        if (String(dataIngred).isEmpty)
        {
            listIsEmpty();
            self.progressCircle.removeFromSuperview();
            return;
        }
        
        addToStack(ingredient : dataIngred);
        DispatchQueue.main.async
        {
            self.ingredientText.text = dataIngred;
            self.progressCircle.removeFromSuperview();
            if(self.attemptSearch())
            {
                return;
            }else
            {
                self.returnHome();
            }
        }
    }
    
    private func listIsEmpty()
    {
        let alert = UIAlertController(title: "Item", message: "This item does not include an ingredient list", preferredStyle: .alert);
        let button = UIAlertAction(title: "Return", style: .cancel, handler: nil);
        alert.addAction(button);
        returnHome();
    }
    
    // adds ingredient to stack
    // Seperates by " , "
    private func addToStack(ingredient : String)
    {
        let object = parseIngredient(ingredient: ingredient);
        ingredientStack = object.returnIngredientList() as [String];
    }
    
    // handle data first API Call
    // Returns in data is nil
    // sets Data description, Name, Company..
    private func handleDataFirst(data: dataList)
    {
        if(data.list == nil)
        {
            attemptSecondAPI();
            return;
        }
        let passParseValue = data.list!.item[0].ndbno!;
        if (passParseValue.isEmpty)
        {
            attemptSecondAPI();
            return;
        }
        attemptSecondParse(parseValue: passParseValue);
        DispatchQueue.main.async
        {
        
            self.containerName.text = data.list!.item[0].name;
            self.barcodeLabel.text = self.barcode;
            self.containerSuccess.text = self.completedBoolS;
            self.containerCompanyName.text = data.list!.item[0].manu;
        }
    }
    // Returns home if error
    // PopViewContoller
    private func returnHome()
    {
        DispatchQueue.main.async
        {
        self.progressCircle.removeFromSuperview();
        self.containerName.text = self.barcode;
        self.containerSuccess.text = self.completdBoolF;
            
            // add action to go home here
        let error = UIAlertController(title: "Error", message: "Barcode Does not exist on database", preferredStyle: .alert);
            let action = UIAlertAction(title: "Return", style: .cancel, handler: { (_) in
                self.navigationController?.popViewController(animated: true) });
        error.addAction(action);
        self.present(error, animated: true, completion: nil);
        }
    }
    // Searches Ingredient List
    // Return False if Arrays are empty both ingrdient and peta
    public func attemptSearch()->Bool
    {
        var textToShow: String = "";
        let progress = ProgressHUD(text: "Looking");
        self.view.addSubview(progress);
        if (petaStack.count < 0 || ingredientStack.count < 0)
        {
            let error = UIAlertController(title: "Failure To Parse", message: "Try again later :(", preferredStyle: .alert);
            let action = UIAlertAction(title: "Close", style: .cancel, handler: nil);
            error.addAction(action);
            self.present(error, animated: true, completion: nil);
            self.progressCircle.removeFromSuperview();
            return false;
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7)
        {

            let instanceCountValue = self.instanceCount();
            let instanceArrayItems = self.instancesArray();
            self.addContainerImage(instancesCount: instanceCountValue);
            
            
            if(instanceArrayItems.count != instanceCountValue )
            {
                self.problemText.text = "Hard time extracting ingredient but we found..";
            }
            else
            {
                if (instanceCountValue > 10)
                {
                    self.problemLabel.text = String(instanceCountValue) + "Too many ingredients Found";
                }
                else if(instanceCountValue == 1)
                {
                    self.problemText.text = String(instanceCountValue) + " Ingredient Found!";
                }
                else if( (UIDevice.current.screenType.rawValue) <= 5)
                {
                    self.problemLabel.text = String(instanceCountValue) + " Ingredients Found!";
                }
                else
                {
                    self.problemLabel.text = String(instanceCountValue) + " Ingredients Found!";
                }
                
                    for index in 0..<instanceArrayItems.count
                    {
                        textToShow += "\(instanceArrayItems[index])\n";
                    }
                    self.problemText.text = textToShow;
                    progress.removeFromSuperview();
            }
            progress.removeFromSuperview();
        }
        return true;
    }
    
    
    public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var searchButtonProgress: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView();
        progress.color = UIColor.blue;
        progress.style = .white;
        progress.frame = CGRect(x: 0, y: 0, width: 100, height: 50);
        progress.layer.cornerRadius = 15;

        return progress;
    }()
    
    private func instanceCount()->Int
    {
        var ticker: Int = 0;
        for i in 0..<ingredientStack.count
        {
            for j in 0..<petaStack.count
            {
                if (ingredientStack[i].contains(petaStack[j]))
                {
                    ticker+=1;
                    break;
                }
            }
        }
        return ticker;
    }
    // return String Array of items
    //
    private func instancesArray()->[String]
    {
        var returnArray = [String]();
        for i in 0..<ingredientStack.count
        {
            for j in 0..<petaStack.count
            {
                if (ingredientStack[i].contains(petaStack[j]))
                {
                    returnArray.append(ingredientStack[i]);
                    break;
                }
            }
        }
   
        return returnArray;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    
    func dietTypesConstaints()
    {
        
        let vegan = CustomView(name: "Vegan", description: "A person who does not eat or use animal products and or byproducts, including bees and insects.", imagePath: "vegan", frame: .init(x: 0, y: 0, width: 150, height: 160));
        let vegetarian = CustomView(name: "Vegetarian", description: "A person who does not eat meat, and sometimes other animal products, especially for moral, religious, or health reasons. This includes but not limited to milk cheese etc.", imagePath: "vegetarian", frame: .init(x: 0, y: 0, width: 150, height: 160));
        let pescetarian = CustomView(name: "Pescetarian", description: "A person who does not eat meat but does eat fish.", imagePath: "fish", frame: .init(x: 0, y: 0, width: 150, height: 160));
        let meat = CustomView(name: "Meat Eater", description: "An animal that feeds on another animal.", imagePath: "meat", frame: .init(x: 0, y: 0, width: 150, height: 160));
        let help = CustomView(name: "Help Us Improve", description: "Hi there, thanks for using my app. To help this application improve email us any bugs you encounter. Please and Thank You!", imagePath: "help", frame: .init(x: 0, y: 0, width: 150, height: 160));
        
        let sumOfViews = (vegetarian.frame.size.width) + (vegan.frame.size.width) + (pescetarian.frame.size.width) + (meat.frame.size.width) + (help.frame.size.width) + 300;
        
        scrollViewInnerContainer.contentSize = CGSize(width: sumOfViews, height: 170);
        print("the sum is", sumOfViews);
        
        dietTypesStack.translatesAutoresizingMaskIntoConstraints = false;
        dietTypesStack.axis  = NSLayoutConstraint.Axis.horizontal;
        dietTypesStack.distribution  = UIStackView.Distribution.equalSpacing;
        dietTypesStack.alignment = UIStackView.Alignment.leading
        dietTypesStack.spacing   = 8.0;
        dietTypesStack.addArrangedSubview(vegan);
        dietTypesStack.addArrangedSubview(vegetarian);
        dietTypesStack.addArrangedSubview(pescetarian);
        dietTypesStack.addArrangedSubview(meat);
        dietTypesStack.addArrangedSubview(help);
    
        dietTypesStack.topAnchor.constraint(equalTo: scrollViewInnerContainer.topAnchor, constant: 5).isActive = true;
   
    }
    
    func c_scrollViewInnerContainer()
    {
        scrollViewInnerContainer.backgroundColor = hexStringToUIColor(hex: "#ebeced");
        scrollViewInnerContainer.topAnchor.constraint(equalTo: scrollViewContainer.topAnchor, constant: 0).isActive = true;
        scrollViewInnerContainer.bottomAnchor.constraint(equalTo: scrollViewContainer.bottomAnchor, constant: 0).isActive = true;
        scrollViewInnerContainer.leadingAnchor.constraint(equalTo: scrollViewContainer.leadingAnchor, constant: 0).isActive = true;
        scrollViewInnerContainer.trailingAnchor.constraint(equalTo: scrollViewContainer.trailingAnchor, constant: 0).isActive = true;
        
        
    }
    
    func c_scrollViewContainer()
    {
        scrollViewContainer.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: 20).isActive = true;
        scrollViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true;
        scrollViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true;
        scrollViewContainer.heightAnchor.constraint(equalToConstant: 170).isActive = true;
    }
    
    func stackViewConstraints()
    {
        stackView.axis  = NSLayoutConstraint.Axis.vertical;
        stackView.distribution  = UIStackView.Distribution.fillEqually;
        stackView.alignment = UIStackView.Alignment.leading;
        stackView.spacing   = 0.5;
        stackView.addArrangedSubview(barcodeLabel);
        stackView.addArrangedSubview(containerName);
        stackView.addArrangedSubview(containerCompanyName);
        stackView.addArrangedSubview(containerSuccess);
        stackView.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    
    var horizontalLine : UIView = {
        
        let line = UIView();
        line.translatesAutoresizingMaskIntoConstraints = false;
        return line;
    }()
    func c_line()
    {
        horizontalLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true;
        horizontalLine.backgroundColor = hexStringToUIColor(hex:"#E1204D");
        horizontalLine.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true;
        horizontalLine.topAnchor.constraint(equalTo: problemText.bottomAnchor, constant: 10).isActive = true;
        horizontalLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true;
        horizontalLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true;
    }
    
    
    // remove this button
    public var searchButton : UIButton = {
        var button = UIButton();
        let width = UIScreen.main.bounds.width
        button.setTitle("Button", for: .normal);
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.frame = CGRect(x: 0, y: 0, width: width, height: 40);
        button.backgroundColor = UIColor.blue;
        return button;
        
    }()
    
    public var imageView : UIImageView = {
        var imageView = UIImageView();
        imageView.image = UIImage(named: "leaf");
        imageView.layer.masksToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 300);
        return imageView;
    }()
    
    public var ingredientLabel : UILabel = {
        var label = UILabel();
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40);
        label.text = "Ingredients";
        label.font = UIFont(name: "Helvetica", size: 19);
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    public var problemLabel : UILabel = {
        
        var problem = UILabel();
        problem.font = UIFont(name: "Helvetica", size: 19);
        problem.translatesAutoresizingMaskIntoConstraints = false;
        problem.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        problem.text = "";
        return problem;
    }()
    
    // stackview
    public var containerName : UILabel = {
        var label = UILabel();
        //lable.frame = CGRect(x: 0, y: 0, width: 200, height: 40);
        label.textAlignment = .left;
        label.textColor = UIColor.white;
        label.font = UIFont(name: "Helvetica", size: 12);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 2;
        label.sizeToFit();
        label.text = "Product name";
        return label;
    }()
    public var containerCompanyName : UILabel = {
        var label = UILabel();
        label.text = "Company name";
        label.textColor = UIColor.white;
        label.font = UIFont(name: "Helvetica", size: 12);
        label.textAlignment = .left;
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    public var containerSuccess : UILabel = {
        var label = UILabel();
        label.textColor = UIColor.white;
        label.text = "Fail or Success";
        label.font = UIFont(name: "Helvetica", size: 12);
        label.textAlignment = .left;
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    
    public var barcodeLabel : UILabel = {
        var label = UILabel();
        label.text = "Barcode";
        label.textColor = UIColor.white;
        label.font = UIFont(name: "Helvetica" , size: 12);
        label.textAlignment = .left;
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    // stack view
    
    
    public var exampleBox : UIView = {
        let box = UIView();
        box.frame = CGRect(x: 0, y: 0, width: 100, height: 100);
        box.backgroundColor = UIColor.green;
        box.translatesAutoresizingMaskIntoConstraints = false;
        return box;
    }()

  
    
    func c_stackView()
    {
        stackView.heightAnchor.constraint(equalToConstant: containerView.frame.size.height / 2).isActive = true;
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2).isActive = true;
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true;
    }
    
    func c_problemLabel()
    {
        problemLabel.bottomAnchor.constraint(equalTo: problemText.topAnchor, constant: 0).isActive = true;
        problemLabel.leadingAnchor.constraint(equalTo: problemText.leadingAnchor, constant: 0).isActive = true;
        problemLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true;
        problemLabel.textColor = hexStringToUIColor(hex: "#8CB618");
    }
    
    func c_problem()
    {
        problemText.topAnchor.constraint(equalTo: ingredientText.bottomAnchor, constant: 30).isActive = true;
        problemText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true;
        problemText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true;
        problemText.heightAnchor.constraint(equalToConstant: 170).isActive = true;
    }
    
    func c_label()
    {
        ingredientLabel.bottomAnchor.constraint(equalTo: ingredientText.topAnchor, constant: 0).isActive = true;
        ingredientLabel.textColor = hexStringToUIColor(hex: "#8CB618");
        ingredientLabel.leadingAnchor.constraint(equalTo: ingredientText.leadingAnchor, constant: 0).isActive = true;
    }
    
    func c_button()
    {
        let width = UIScreen.main.bounds.width
        searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true;
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        searchButton.widthAnchor.constraint(equalToConstant: width).isActive = true;
        searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true;
        searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true;
    }
    
    func c_text()
    {
        let width = UIScreen.main.bounds.width
        ingredientText.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true;
        ingredientText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true;
        ingredientText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true;
        ingredientText.heightAnchor.constraint(equalToConstant: 170).isActive = true;
        ingredientText.widthAnchor.constraint(equalToConstant: width).isActive = true;
        
    }
    
    func c_view()
    {
        containerView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 100).isActive = true;
        if ((UIDevice.current.screenType.rawValue) <= 5)
        {
            print("Print screen size ", UIDevice.current.screenType.rawValue);
            containerView.heightAnchor.constraint(equalToConstant: 190).isActive = true;
            containerView.widthAnchor.constraint(equalToConstant: 220).isActive = true;
        }
        containerView.heightAnchor.constraint(equalToConstant: 220).isActive = true;
        containerView.widthAnchor.constraint(equalToConstant: 250).isActive = true;
        containerView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0).isActive = true;
        
    }
    
    func c_image()
    {
        let w = UIScreen.main.bounds.width;
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true;
        imageView.widthAnchor.constraint(equalToConstant: w).isActive = true;
        
        
    }
    func c_scrollView()
    {
        scrollView.backgroundColor = UIColor.white;
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true;
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true;
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true;
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true;
    }
    // new end
}
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: Int {
        case iPhones_4_4S = 4;
        case iPhones_5_5s_5c_SE = 5
        case iPhones_6_6s_7_8 = 6
        case iPhones_6Plus_6sPlus_7Plus_8Plus = 7
        case iPhones_X_XS = 10
        case iPhone_XR = 11
        case iPhone_XSMax = 12
        case unknown = 0;
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
}


}

