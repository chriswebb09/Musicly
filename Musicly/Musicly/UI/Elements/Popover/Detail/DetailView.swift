import UIKit

final class NewPlaylistView: UIView {
    
    // Input for playlist name
    
    var playlistNameField: TextFieldExtension = {
        var playlistNameField = TextFieldExtension()
        playlistNameField.layer.borderColor = DetailViewConstants.mainColor.cgColor
        playlistNameField.layer.cornerRadius = DetailViewConstants.largeCornerRadius
        playlistNameField.layer.borderWidth = DetailViewConstants.borderWidth
        playlistNameField.placeholder = "Name your playlist"
        playlistNameField.font = UIFont(name: "Avenir-Book", size: 20)!
        return playlistNameField
    }()
    
    private var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.backgroundColor = DetailViewConstants.mainColor
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = DetailViewConstants.titleFont
        return titleLabel
    }()
    
    private var detailsTextView: UITextView = {
        var detailsTextView = UITextView()
        detailsTextView.sizeToFit()
        detailsTextView.textAlignment = .center
        detailsTextView.isScrollEnabled = true
        return detailsTextView
    }()
    
    let doneButton: UIButton = {
        var button = UIButton()
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(PlaylistViewControllerConstants.mainColor, for: .normal)
        button.setTitle("Done", for: .normal)
        button.layer.borderColor = PlaylistViewControllerConstants.mainColor.cgColor
        button.layer.borderWidth = 1.5
        if let popTitle = button.titleLabel, let font = UIFont(name: "Avenir-Book", size: 20) {
            popTitle.font = font
        }
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        backgroundColor = UIColor.white
        configureShadow(for: layer)
        layer.borderWidth = 1.5
        layer.borderColor = PlaylistViewControllerConstants.mainColor.cgColor
    }
    
    private func configureShadow(for layer: CALayer) {
        layer.cornerRadius = DetailViewConstants.cornerRadius
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = DetailViewConstants.shadowOpacity
        layer.masksToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:layer.cornerRadius).cgPath
    }
    
    func configureView() {
        titleLabel.text = "Create Playlist"
        layoutSubviews()
        setupConstraints()
    }
    
    private func setupPlaylistNameFieldConstraints(nameField: UITextField) {
        addSubview(playlistNameField)
        playlistNameField.translatesAutoresizingMaskIntoConstraints = false
        playlistNameField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playlistNameField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playlistNameField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.14).isActive = true
        playlistNameField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: DetailViewConstants.fieldWidth).isActive = true
    }
    
    private func setupTitleLabelConstraint(titleLabel: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: DetailViewConstants.heightMultiplier).isActive = true
    }
    
    private func setupDoneButtonConstraints(doneButton: UIButton) {
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: DetailViewConstants.heightMultiplier).isActive = true
        doneButton.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupConstraints() {
        setupPlaylistNameFieldConstraints(nameField: playlistNameField)
        setupTitleLabelConstraint(titleLabel: titleLabel)
        setupDoneButtonConstraints(doneButton: doneButton)
    }
}
