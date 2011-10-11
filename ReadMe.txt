### WhatsLeftChef ###
Author: Andrew Carpenter, Lexington, KY

================================================================================
DESCRIPTION:
  
The application uses the domain of organizing and presenting recipes based on the contents of your fridge.
 
Amongst the features included are:
* A view that shows a list of meals that is contingent on the ingredients being available in your fridge. (currently must have all the ingredients)
* A view that shows a list of all the items currently in your fridge.
* An included sqlite3 recipe database with over 2 recipes!
 
================================================================================
BUILD REQUIREMENTS:
 
Mac OS X v10.6 or later; Xcode 3.1.3 or later; iPhone OS 3.1.
 
================================================================================
RUNTIME REQUIREMENTS:
 
Mac OS X v10.6 or later; iPhone OS 3.1.
 
================================================================================
PACKAGING LIST:
 
Model and Model Classes
-----------------------
Food.{h,m}
A model used for storing information about an item in the fridge. (not implemented)

whatsleftchef.db
An sqlite3 database representing both fridge content information and recipe information.

Application Configuration
-------------------------
 
WhatsLeftChefAppDelegate.{h,m}
MainWindow.xib
Application delegate that sets up a navigation controller that in turn loads a view controller to manage a your fridge.
 
View Controllers
------------------------
 
RootViewController.{h,m}
View controller to manage an home screen that guides the user to the proper decisions.
This is the "topmost" view controller in the Recipes stack.

GuestSizeViewController.{h,m}
GuestSizeViewController.xib
View controller that displays a picker view to select the party size.

FridgeViewController.{h,m}
FridgeViewController.xib
View controller that displays a table view of your fridge's current contents.

ManualFridgeItemAddViewController.{h,m}
ManualFridgeItemAddViewController.xib
View controller that will eventually display view to manually add an item to the fridge table in whatsleftchef.db

MealTypeSelectViewController.{h,m}
MealTypeSelectViewController.xib
View controller that allows the user to select what type of meal they would like to eat (not implemented)

MealsViewController.{h,m}
MealsViewController.xib
View controller that displays a list of available meals.

Table view cells
----------------

RecipeListTableViewCell.xib
A table view cell that displays information about a Recipe.  It uses individual subviews of its content view to show the name, picture, description, and preparation time for each recipe.
 
FridgeItemTableViewCell.xib
A table view cell that displays name, volume remaining, and picture of a fridge item.
 
===========================================================================
CHANGES FROM PREVIOUS VERSIONS:

Version 0.1
- pre-pre-pre-pre alpha version.

================================================================================
