//
//  MovieDetailsViewController.swift
//  rottentomatoes
//
//  Created by Nekkalapudi, Satish on 9/12/16.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var fullPosterImage: UIImageView!
    @IBOutlet weak var movieDetailsContainer: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var criticsScoreLabel: UILabel!
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!

    var movie: RottenTomatoesMovie?
    var movieCellSender: MovieTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.movie != nil {
            self.renderViewForMovie(movie!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMovieCellSender(movieCell: MovieTableViewCell) {
        self.movieCellSender = movieCell
        self.movie = movieCell.movie!
    }

    func renderViewForMovie(movie: RottenTomatoesMovie) {
        self.navigationItem.title = movie.title
        self.fullPosterImage.setImageWithURL(NSURL(string: movie.originalPosterUrl), placeholderImage: self.movieCellSender!.thumbnailPosterImage.image)
        self.movieTitleLabel.text = "\(movie.title) (\(movie.year))"
        self.criticsScoreLabel.text = "Critics Score: \(movie.criticsScore), Audience Score: \(movie.audienceScore)"
        self.mpaaRatingLabel.text = movie.mpaaRating
        self.synopsisLabel.text = movie.synopsis
    }
}
