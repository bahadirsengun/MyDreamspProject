//
//  SSSTableViewCell.swift
//  myDream
//
//  Created by Bircan Sezgin on 5.05.2023.
//

import UIKit

protocol SSSTableViewCellProtocol{
    func asnwerShow(indexPath: IndexPath)
}

class SSSTableViewCell: UITableViewCell {
    
    @IBOutlet weak var soruBasligiLabel: UILabel!

    var hucreProtocol: SSSTableViewCellProtocol?
    var indexPath: IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func answerShow(_ sender: Any) {
        
        if let button = sender as? UIButton {
            applyButtonEffect(button: button)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.hucreProtocol?.asnwerShow(indexPath: self.indexPath!)
        }
        
    }
    
    // MARK: - Button Effect
    func applyButtonEffect(button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            button.alpha = 0.7
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = CGAffineTransform.identity
                button.alpha = 1.0
            })
        })
    }
}
