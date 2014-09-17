//
//  MoviesViewController.swift
//  rottentomatoes
//
//  Created by Nekkalapudi, Satish on 9/12/16.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var moviesSearchBar: UISearchBar!

    var moviesArray = Array<RottenTomatoesMovie>()
    var visibleMoviesArray = Array<RottenTomatoesMovie>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: "tableRefreshCallback:", forControlEvents: UIControlEvents.ValueChanged)
        self.movieTableView!.addSubview(refreshControl)
        self.reloadData()
    }

    func reloadData(showHud: Bool = true, refreshControl: UIRefreshControl? = nil) {
        if showHud {
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        getMoviesFromRottenTomatoes() {
            (moviesResultDictionary: NSDictionary) -> () in
            let movieDictionaries = moviesResultDictionary["movies"] as? NSArray
            var moviesArray = Array<RottenTomatoesMovie>()
            for movieDictionary in movieDictionaries! {
                let movie = getRottenTomatoesMovieInstance(movieDictionary as NSDictionary)
                moviesArray.append(movie)
            }
            self.moviesArray = moviesArray
            self.visibleMoviesArray = moviesArray
            if showHud {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            refreshControl?.endRefreshing()
            self.movieTableView.reloadData()
        }
    }
    func tableRefreshCallback(refreshControl: UIRefreshControl) {
        reloadData(showHud: false, refreshControl: refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visibleMoviesArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieTableViewCell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieTableViewCell
        let movie = self.visibleMoviesArray[indexPath.row]
        movieTableViewCell.formatWithMovie(movie)

        return movieTableViewCell
    }


    func updateVisibleMovies(filterTitle substring: String) {
        if substring == "" {
            self.visibleMoviesArray = self.moviesArray
        } else {
            var visibleMoviesArray = Array<RottenTomatoesMovie>()
            for movie in self.moviesArray {
                let rangeValue = (movie.title as NSString).rangeOfString(substring, options: NSStringCompareOptions.CaseInsensitiveSearch)
                if rangeValue.location != NSNotFound {
                    visibleMoviesArray.append(movie)
                }
            }
            self.visibleMoviesArray = visibleMoviesArray
        }
        self.movieTableView.reloadData()
    }

    // UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        updateVisibleMovies(filterTitle: searchText)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let movieDetailsViewController = segue.destinationViewController as? MovieDetailsViewController {
            if let movieCell = sender as? MovieTableViewCell {
                movieDetailsViewController.setMovieCellSender(movieCell)
            }
        }
    }
}

