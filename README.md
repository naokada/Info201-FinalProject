# [Place lookup](https://paulyoo.shinyapps.io/Info201-FinalProject/)

## Data set description

We are working with a data set containing information of all stores registered on Google Place (resource https://developers.google.com/places/web-service/details)

The data set is provided by the Google Places API. Google Places’ main function is to host businesses. Businesses list their information such as location and picture so Google users can find them on the map. This API is very convenient for us because numerous shops and stores have registered themselves on Google Place, granting us easy access to all relevant information about their businesses. For example, we can obtain information such as address, names, hours, price level, photos, and even reviews.

The data set will be turned into an interactive webpage that user uses to find a specific place and know about its basic information in deeper level. For example, we will provide data analysis of price levels and reviews which are not only helpful to customers but also to the store owners. Or we will include more detailed information about the time frame of open hours than the google map.

## Function
1. Users Enter the name of a location or click a location on the interactive map
The user can type keyword in the input form or can click a location on the interactive map(the first tab of the maps). This application will take the data about the place you want to see!
[![https://gyazo.com/c38981fe2c89f856904468ea47c3b0fe](https://i.gyazo.com/c38981fe2c89f856904468ea47c3b0fe.gif)](https://gyazo.com/c38981fe2c89f856904468ea47c3b0fe)

2. Users can also filter places of interest based on what type of location they are intersted in. For example, cafe, library, etc.
The user is needed to select type of the place, and this application provides information based on the type you selected.

3. Users can interact with a slider that lets them slide through all the available locations. By moving the slider, the user can skim through all the places.

4. Enjoy our application!
On the widget on left, the user can see how far the place is from the point the user clicked(default is University of Wanshinton).
In the map2, the user can see the location about the places nearby from the place the user selected.

[![https://gyazo.com/607d31b2c7d0850f17cfcd6a9646c76b](https://i.gyazo.com/607d31b2c7d0850f17cfcd6a9646c76b.gif)](https://gyazo.com/607d31b2c7d0850f17cfcd6a9646c76b)


## Description of the presentation  

1.  We used shiny to present our data. We get all our data from the open Google places API and organize and process the data through RStudio.

2.  We used leaflet to draw interactive graphs of the dataset. We also extracted detailed information from the dataset.

3.  We will also be triangulating the user’s position to restaurants in the area to find the closest restaurant. We also answered answered the question regarding the locations of location by visualizing it on our map.
