//
//  RottenAFNetworking.swift
//  rottentomatoes
//
//  Created by Nekkalapudi, Satish on 9/16/14.
//  Copyright (c) 2014 Nekkalapudi, Satish. All rights reserved.
//


import Foundation
import UIKit

let rottenRestApiURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"



func getMoviesFromRottenTomatoes(callback: (NSDictionary) -> ()) {
    let request = NSMutableURLRequest(URL: NSURL.URLWithString(rottenRestApiURL))
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) in
        var errorValue: NSError? = nil
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue)
        if parsedResult != nil {
            println("Fetch Data ...")
            let moviesResultDictionary = parsedResult! as NSDictionary
            callback(moviesResultDictionary)
        } else {
            TSMessage.showNotificationWithTitle("Network error", subtitle: "Couldn't connect to the servser.", type: TSMessageNotificationType.Error)
        }
    })
}

var rottenTomatoesMovieObjects = Dictionary<String, RottenTomatoesMovie>()

func getRottenTomatoesMovieInstance(movieDictionary: NSDictionary) -> RottenTomatoesMovie {
    let movieId = movieDictionary["id"] as NSString
    var movie: RottenTomatoesMovie?
    if let movieInstance = rottenTomatoesMovieObjects[movieId] {
        movie = movieInstance
    } else {
        movie = RottenTomatoesMovie(movieDictionary: movieDictionary)
        rottenTomatoesMovieObjects[movieId] = movie
    }
    return movie!
}
