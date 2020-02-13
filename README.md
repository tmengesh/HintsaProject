# HintsaProject

Training Log is a sample application designed to log the user's exercise session. The app consists of two views. 
Landing view (Viewcontroller) and pop up log view (LogExerciseVC) a custom cell (SessionsTableViewCell). 

The app designed following the provided design refrence (https://projects.invisionapp.com/share/36NGNO9BR8A ),
and I used extension classes to round button and image view.  

To permanently store log data the app makes the most of out using mobile's local storage using CoreData and UserDefaults. 
Core Data is a framework that one uses to manage the model layer objects in your application. and UserDefautls is a .plist 
file in your app’s package and you can use it to set and get simple pieces of data.

I used CoreData to log Sessions and later fetch and display them on tableview using custom cells. And user defaults are 
used to store totalEndurance, totalStrength, and totalMobility. 

In CoreData an entry is defined by the name "ExerciseSession" with attributes "completedAt: Date", "category: String", 
"trainingDescription:String" and "durationInMinutes: Integer32". 

When the app launches the user lands on the home page... and for the first time since isn't any saved data table view is 
blank and Total values are 0 minutes. 

When the user presses + button a popup view will be shown with an option to log sessions. Once the user enters a 
description, chooses a category (Endurance is default) , duration in minutes, and date using UIdate picker and 
presses "SAVE ENTRY", input validator is called to check if text fields aren't empty and duration is a numeric value. 

If it passes validation then the app writes the new entry to "ExerciseSession".  and sends a notification to the home 
screen to update its values, that's when the table view is reloaded and total values are updated as per the previously 
entered content, if not the app shows notification to the user to reenter values. 

Once the user presses X button and returns to the landing view s/he will see total minute/s updated and a new row 
added to a table view with all the descriptions saved. 

As an extra feature, I added an option to delete row (entry from database). From the table view cells by swiping 
cell to the left and press delete. Of course, the app updates respectively meaning removing the cell row from the 
table view, delete the deleted data from our entry and update the total by subtracting minute value from the deleted cell.    

To run the app, clone or download the project, open the HintsaLogUI.xcodeproj on Xcode, build and run it. 
If possible use iPhone 8 Simulator as the design resembles with the one that is provided on the guide :) 
