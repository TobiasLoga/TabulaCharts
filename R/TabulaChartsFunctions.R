#############################################################################################X
## TabulaCharts - TABULA Chart functions -------------------------------------------------------------
#############################################################################################X

#. -------------------------------------------------------------------------------------------

## LoadChartSettings ()
#' Load charts settings 
#'
#' The function loads the settings of the chart. 
#'
#' @param mySourceType The type of data source; possible entries: "RDA" (default), "Excel"
#' @param mySheetName The name of the Excel sheet that includes the data table to be loaded
#' @param myFileName The name of the file that includes the data table to be loaded
#'
#' @return a dataframe of the type "ChartData" or "ChartSettings"
#'
#' @examples
#' # Load the "ChartData" template and the chart settings from an Excel file located 
#' # in "Input/Template/Excel/"  
#' 
#' 
#' # 1 Chart displaying the energy balance of the building fabric and the heat need 
#' 
#' ChartData_HeatNeed <- 
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_HeatNeed",
#'     mySheetName =     "DF_ChartData"
#'   )
#'      
#' ChartSettings_HeatNeed <-
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_HeatNeed",
#'     mySheetName =     "DF_Settings"
#'   )
#'
#' head (ChartData_HeatNeed)
#' head (ChartSettings_HeatNeed)
#'
#'
#' # 2 Chart displaying the final energy demand 
#'
#' ChartData_FinalEnergy <- 
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_FinalEnergy",
#'     mySheetName =     "DF_ChartData"
#'   )
#' 
#' ChartSettings_FinalEnergy <- 
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_FinalEnergy",
#'     mySheetName =     "DF_Settings"
#'   )
#' 
#' head (ChartData_FinalEnergy)
#' head (ChartSettings_FinalEnergy)
#' 
#' 
#' # 3 Chart displaying expectation ranges of the heat need and the final energy demand
#' 
#' ChartData_ExpectationRanges <- 
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_Uncertainties",
#'     mySheetName =     "DF_ChartData"
#'   )
#' 
#' ChartSettings_ExpectationRanges <- 
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_Uncertainties",
#'     mySheetName =     "DF_Settings"
#'   )
#'  
#'  head (ChartData_ExpectationRanges)
#'  head (ChartSettings_ExpectationRanges)
#'  
#'  
#' @export
LoadChartSettings <- function (
    mySourceType = "RDA",
    mySheetName,
    myFileName = "ChartSettings"
    ) {
  
  ## Function script
  if (mySourceType == "RDA") {
    Data_HeatNeedChart <-
        load (
          file = paste0 ("Input/Template/RDA/", myFileName, ".rda")
        )
  } else {
    DF_ChartData <-
      openxlsx::read.xlsx (
        paste0 ("Input/Template/Excel/", myFileName, ".xlsx"),
        sheet = mySheetName,
        colNames = TRUE
        ) 
  }
  
  return (DF_ChartData)
}


#. ---------------------------------------------------------------------------------------------


## ShowBarChart ()
#' Show a bar chart of the energy performance calculation 
#'
#' The function uses the output from the package MobasyModel to create a bar chart  
#' to the dataframe template for the heat need data.
#'
#' @param  myChartSettings A dataframe including the chart settings
#' @param  myChartData     A dataframe including the data structure, labels, chart colours, sources 
#' @param  DF_EnergyData   A dataframe including the energy data to be displayed 
#' @param  Index_Dataset   An integer indicating which dataset (row of DF_EnergyData) to be displayed
#' @param  Code_Language   A character string to indicate the language of the chart labels;
#' English: "ENG", German = "GER", other language = "XXX" 
#' The labels are entered in the respective columns in "myChartData"
#' @param  Set_MaxY_Auto   A boolean indicating if automatic scaling is to be applied 
#' or if predefined MaxY values from "myChartSettings" should be used   
#' @param  Do_FlipChart    A boolean indicating if the bar chart should be flipped 
#' from vertical columns to horizonal bars 
#' @param  stackStrategy   A character string indicating the handling of negative values; 
#' the options are: 
#' 'samesign': only stack values if the value to be stacked has the same sign as the currently cumulated stacked value.
#' 'all': stack all values, irrespective of the signs of the current or cumulative stacked value.
#' 'positive': only stack positive values.
#' 'negative': only stack negative values.
#' see: https://echarts.apache.org/en/option.html#series-bar.stack
#'
#' @return A bar chart. In order to show the chart in the browser call: options (viewer = NULL) 
#'
#' @examples
#' 
#' ## Only call this if you want to show the chart in the browser 
#' options (viewer = NULL) 
#' 
#' 
#' ## Load the energy data
#' load ("Input/Data/Example/myOutputTables.rda") 
#' # This is a dataframe generated by the functions MobasyCalc () and EnergyProfileCalc () 
#' # of the R package MobasyModel
#' DF_EnergyData <-
#'   myOutputTables$DF_Display_Energy
#' 
#' ## 1 Heat need
#' ## Chart displaying the energy balance of the building fabric and the heat need
#' ## Example building: "DE.MOBASY.WBG.0008.05"
#' 
#' ChartData_HeatNeed <-
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_HeatNeed",
#'     mySheetName =     "DF_ChartData"
#'   )
#' 
#' ChartSettings_HeatNeed <-
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_HeatNeed",
#'     mySheetName =     "DF_Settings"
#'   )
#' 
#' ShowBarChart  (
#'   myChartSettings = ChartSettings_HeatNeed,
#'   myChartData     = ChartData_HeatNeed,
#'   DF_EnergyData   = DF_EnergyData,
#'   Index_Dataset   = which (DF_EnergyData$ID_Dataset == "DE.MOBASY.WBG.0008.05"),
#'   Code_Language   = "GER",
#'   #Code_Language  = "ENG",
#'   Set_MaxY_Auto   = TRUE,
#'   Do_FlipChart    = FALSE,
#'   stackStrategy   = 'samesign'
#' )
#' 
#' 
#' ## 2 Final energy
#' ## Chart displaying the final energy demand
#' ## Example building: "DE.MOBASY.NH.0033.05"
#' 
#' ChartData_FinalEnergy <-
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_FinalEnergy",
#'     mySheetName =     "DF_ChartData"
#'   )
#' 
#' ChartSettings_FinalEnergy <-
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_FinalEnergy",
#'     mySheetName =     "DF_Settings"
#'   )
#' 
#' ShowBarChart  (
#'   myChartSettings = ChartSettings_FinalEnergy,
#'   myChartData     = ChartData_FinalEnergy,
#'   DF_EnergyData   = DF_EnergyData,
#'   Index_Dataset   = which (DF_EnergyData$ID_Dataset == "DE.MOBASY.NH.0033.05"),
#'   Code_Language   = "GER",
#'   #Code_Language  = "ENG",
#'   Set_MaxY_Auto   = TRUE,
#'   Do_FlipChart    = FALSE,
#'   stackStrategy   = 'samesign'
#' )
#' 
#' 
#' ## 3 Expectation ranges
#' ## Chart displaying expectation ranges of the heat need and the final energy demand
#' ## Example building: "DE.MOBASY.NH.0033.05"
#' 
#' ChartData_ExpectationRanges <-
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_Uncertainties",
#'     mySheetName =     "DF_ChartData"
#'   )
#' 
#' ChartSettings_ExpectationRanges <-
#'   LoadChartSettings (
#'     mySourceType =    "Excel",
#'     myFileName =      "ChartSettings_Uncertainties",
#'     mySheetName =     "DF_Settings"
#'   )
#' 
#' ShowBarChart  (
#'   myChartSettings = ChartSettings_ExpectationRanges,
#'   myChartData     = ChartData_ExpectationRanges,
#'   DF_EnergyData   = DF_EnergyData,
#'   Index_Dataset   = which (DF_EnergyData$ID_Dataset == "DE.MOBASY.NH.0033.05"),
#'   Code_Language   = "GER",
#'   #Code_Language   = "ENG",
#'   Set_MaxY_Auto   = TRUE,
#'   Do_FlipChart    = TRUE,
#'   stackStrategy   = 'all'
#' )
#' 
#' 
#' @export
ShowBarChart <- function (
    myChartSettings, 
    myChartData,      # Data structure and labels, template for numbers 
    DF_EnergyData,
    Index_Dataset = 1,
    Code_Language = "ENG",
    Set_MaxY_Auto = TRUE,
    Do_FlipChart = FALSE,
    stackStrategy = 'samesign' 
    ) {
  
  ## Assignments for testing
  # #
    # myChartSettings <- ChartSettings_HeatNeed
    # myChartData <- ChartData_HeatNeed
    # #DF_EnergyData  <- DF_EnergyData
    # Index_Dataset <- 1
    # Code_Language <- "ENG"
    # Set_MaxY_Auto = TRUE
    # Do_FlipChart = FALSE
    # stackStrategy = 'samesign' 
  # #
    # myChartSettings <- ChartSettings_FinalEnergy
    # myChartData <- ChartData_FinalEnergy
    # #DF_EnergyData  <- DF_EnergyData
    # Index_Dataset <- 1
    # Code_Language <- "ENG"
    # Set_MaxY_Auto = TRUE
    # Do_FlipChart = FALSE
    # stackStrategy = 'samesign' 
  # #  
    # myChartSettings <- ChartSettings_ExpectationRanges
    # myChartData     <- ChartData_ExpectationRanges
    # #DF_EnergyData   <- DF_EnergyData
    # #Index_Dataset      <- 141
    # #Index_Dataset      <- 61
    # #Index_Dataset <- which (DF_EnergyData$ID_Dataset == "DE.MOBASY.WBG.0008.05")
    # Index_Dataset <- which (DF_EnergyData$ID_Dataset == "DE.MOBASY.NH.0033.05")
    # Code_Language      <- "GER"
    # #Code_Language      <- "ENG"
    # Set_MaxY_Auto <- TRUE
    # Do_FlipChart = TRUE
    # stackStrategy = 'all'
  # # 
  
  ## Function script
  
  n_Variable <- nrow (myChartData)
  
  myDF_EnergyData <- 
    rep (NA,  n_Variable)
  
  myDF_EnergyData <- 
    matrix (nrow = 1, ncol = n_Variable)
  colnames (myDF_EnergyData) <- myChartData$VarName

  for (i_Var in (1:n_Variable)) {
    
    myDF_EnergyData [i_Var] <-
    AuxFunctions::Parse_StringAsCalculation (
      myChartData$VarName_Source [i_Var], 
      DF = DF_EnergyData [Index_Dataset, ], 
      myDecimalPlaces = 2
    )
    
  } 

  # myDF_EnergyData <-  
  #   DF_EnergyData [myChartData$VarName_Source]
  # colnames (myDF_EnergyData) <- myChartData$VarName
  
  
  myChartData <- 
    myChartData [order (myChartData$Index_Sequence), ]
  # only necessary to supplement the bar colours in the right order 
  
  myChartData$Energy <- 
    round (
      as.numeric (
        t (myDF_EnergyData [
          1, 
          myChartData$VarName])
      ), 
      1
    )
  

  myChartSettings$ChartTitle <-
    myChartSettings [ , paste0 ("ChartTitle_", Code_Language)]
  
  myChartSettings$ChartSubTitle <-
    myChartSettings [ , paste0 ("ChartSubTitle_", Code_Language)]

  myChartSettings$AxisTitle_x <-
    myChartSettings [ , paste0 ("AxisTitle_x_", Code_Language)]
  
  myChartSettings$AxisTitle_y <-
    myChartSettings [ , paste0 ("AxisTitle_y_", Code_Language)]
  
  
  myChartData$Category <-
    myChartData [ , paste0 ("Category_", Code_Language)]
  


  myChartData$Label <- factor (
    myChartData [ , paste0 ("Label_", Code_Language)],
    levels = unique (myChartData [ , paste0 ("Label_", Code_Language)])
  ) 


  #myChartSettings$FontSize <- 20
  #myChartSettings$FontSize_Legend <- 20
  #myChartSettings$AxisInterval <- 10

  

  myChart <-
    myChartData |>
      group_by  (Label) |>
      e_charts  (Category) |>
      e_x_axis  (axisLabel = list (fontSize = myChartSettings$FontSize)) |>
      e_bar     (Energy, 
                 stack = 'Category',
                 stackStrategy = stackStrategy
                 ) |>
      e_title   (text = myChartSettings$ChartTitle,
                 left = 'center', # Wow!
                 top = '2%',
                 textStyle = list (fontSize = myChartSettings$FontSize),
                 subtext = myChartSettings$ChartSubTitle,
                 subtextStyle = list (fontSize = myChartSettings$FontSize)
                 # textVerticalAlign = 'middle'
                 # textAlign = 'center',
                 # subtextStyle = list (align = 'center')
                 )  |>
      e_color   (color = myChartData$Colour_Bar) |>
      e_legend  (bottom = '2%', 
                 textStyle = list (fontSize = myChartSettings$FontSize_Legend)
                 )  |>
      e_y_axis  (name = myChartSettings$AxisTitle_y,
                 nameLocation = 'center',
                 nameGap = 50,
                 axisLabel = list (fontSize = myChartSettings$FontSize),
                 max = if (Set_MaxY_Auto == FALSE) {
                   myChartSettings$AxisMax_y
                   } else {
                   NA }, 
                 interval    = myChartSettings$AxisInterval_y,
                 minInterval = myChartSettings$AxisMinInterval_y,
                 maxInterval = myChartSettings$AxisMaxInterval_y
                 #triggerEvent = TRUE, # kann eine Meldung triggern 
                 #axisLabel = list (interval = 10) should work but doesn't
                 #axisTick = list (show = TRUE) should work but doesn't
                 #axisLine = list (show = TRUE) should work but doesn't
                 ) |>
      # e_datazoom (id = 'dataZoomY',
      #             type = 'slider',
      #             y_index = c (1, 0),
      #             filterMode = 'none' #'filter'
      #            ) |>
      ## This is working, but only zoom in, not zoom out 
      # (for example in order to maintain the same scaling for building variants)
      # e_zoom     ( # zoom action
      #           dataZoomIndex = 0,
      #           startValue = 0,
      #           endValue = 'dataMax' ,  #50,
      #           btn = "zoomBtn"
      #         ) |>
      # e_button   (
      #           id = "zoomBtn",
      #           position = "top",
      #           class = "btn btn-primary",
      #           "Zoom"
      #         ) |>
      e_text_style (fontSize = myChartSettings$FontSize) |>
      e_tooltip (trigger = "axis"
                 # alwaysShowContent = TRUE,
                 # position = list ('50%', '50%'),
                 ) |>
      e_grid    (show = TRUE, 
                 top    = sprintf ("%1.0f%%", 100 * myChartSettings$Grid_Top), 
                 bottom = sprintf ("%1.0f%%", 100 * myChartSettings$Grid_Bottom),
                 left   = sprintf ("%1.0f%%", 100 * myChartSettings$Grid_Left), 
                 right  = sprintf ("%1.0f%%", 100 * myChartSettings$Grid_Right) 
                ) |>
      # e_toolbox_feature ('dataZoom') |>
      # e_toolbox_feature (feature = 'reset') |>
      e_toolbox_feature ('dataView') |>
      e_toolbox_feature ('saveAsImage') #|>
      # e_on      (
      #           query = list (axisLabel = '0'),
      #           #handler = "function() {echarts4r.e_y_axis(max=400)}" # not working
      #           #handler = "function() {alert('Value clicked')}" # works
      # )

  
if (Do_FlipChart == TRUE) {
  myChart |>
    e_flip_coords ()
} else {
  myChart
}

  
} # End function ShowBarChart ()


#. ---------------------------------------------------------------------------------------------



