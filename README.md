# Assignment B4
## Shiny app to explore the life expectancy of people in different continents during 1952 to 2007

This app is part a part of assignment B4 in STAT 545B course. Among the two options, I prefered **Option C** to accomplish the assignment B4, therefore I added some additional features to Assignment B3 app. Before jumping into the description of the app and data set, I would like to show you the app first. [Click here to see the app](https://mhmondol.shinyapps.io/Assignment_B4/).

### Data set used and rationale
The data set can be found [here](https://www.gapminder.org/data/). Besides, it is convenient to use from **gapminder** R package. For each of 142 countries, the package provides values for life expectancy, GDP per capita, and population, every five years, from 1952 to 2007. The app will provide valuable insights as follows-


#### Exploratory analysis tab

 - A detailed table of summary statistics (**Table 1**) of life expectancy for different continents is calculated at various time point. The app allows to download the table as well.
 - A graphical presentation of that summary statistics (**Figure 1**) is constructed. The graph can be downloaded at dimension which is autimatically adjusted with the inputs.
 - A compariable scatter plot for continents can be found in the app (**Figure 2**). A continent-wise linear model is fitted in the same graph. The graph is interactive as well.
 - A detailed data set (**Data set 1**) that is searched through various inputs. Also, the data set is allowed to be downloaded in csv file. Besdies, data sorting, filtering, searching are possible there.

#### Time series graphics tab

 - A time series plot is constructed for life expectancy from 1952 to 2007 for different countries. Besides, the plot will allows to compare the trend in different countries. The graph is interactive as well.






