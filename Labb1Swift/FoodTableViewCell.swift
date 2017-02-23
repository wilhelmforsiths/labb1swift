

import UIKit

class FoodTableViewCell: UITableViewCell {

    var name : String?
    var number : Int?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kcalLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
