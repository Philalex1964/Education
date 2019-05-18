
import UIKit

class NoteImageTableViewCell: NoteTableViewCell {

  // MARK: - IBOutlets
  @IBOutlet fileprivate var noteImage: UIImageView!
}

// MARK: - Internal
extension NoteImageTableViewCell {

  override func updateNoteInfo(note: Note) {
    super.updateNoteInfo(note: note)
    
    noteImage.image = note.image
  }
}


