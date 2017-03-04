

import UIKit

class FoodTableViewCell: UITableViewCell {

    var name : String?
    var number : Int?
    var kcal : Int = 0
    
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
