#############################################################################################X
## TabulaCharts - TABULA Chart functions -------------------------------------------------------------
#############################################################################################X

#. -------------------------------------------------------------------------------------------

## LoadExcelChartParameters ()
#' Load charts settings and templates from Excel 
#'
#' The function loads the settings of the chart. 
#'
#' @param myDataFrameType The dataframe type: "ChartSettings" (default) or "ChartDataTemplate"
#' @param myCharType The chart type: "HeatNeed", "FinalEnergy" or "ExpectationRanges"
#'
#' @return a dataframe of the type "ChartData" or "ChartSettings"
#'
#' @examples
#' # Load the chart data template and the chart settings  
#' # from an Excel file located at "Input/Excel/"  
#' 
#' # (1) Chart displaying the energy balance of the building fabric and the heat need 
#' 
#' ChartSettings_HeatNeed <-
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartSettings",
#'     myChartType     = "HeatNeed"
#'   )
#'
#' ChartData_HeatNeed <- 
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartDataTemplate",
#'     myChartType     = "HeatNeed"
#'   )
#'      
#'  head (ChartSettings_HeatNeed)
#'  head (ChartData_HeatNeed)
#'
#'
#' # (2) Chart displaying the final energy demand 
#' 
#' ChartSettings_FinalEnergy <-
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartSettings",
#'     myChartType     = "FinalEnergy"
#'   )
#'
#' ChartData_FinalEnergy <- 
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartDataTemplate",
#'     myChartType     = "FinalEnergy"
#'   )
#'      
#'  head (ChartSettings_FinalEnergy)
#'  head (ChartData_FinalEnergy)
#'
#'
#' # (3) Chart displaying expectation ranges of the heat need and the final energy demand
#' 
#' ChartSettings_ExpectationRanges <-
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartSettings",
#'     myChartType     = "ExpectationRanges"
#'   )
#'
#' ChartData_ExpectationRanges <- 
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartDataTemplate",
#'     myChartType     = "ExpectationRanges"
#'   )
#'      
#'  head (ChartSettings_ExpectationRanges)
#'  head (ChartData_ExpectationRanges)
#'  
#'  # Export the RDA files 
#'  # Files can later be copied to the subedirectory "data" to be included in the R package
#'  
#'  save (ChartSettings_HeatNeed,          file = "ChartSettings_HeatNeed.rda")
#'  save (ChartSettings_FinalEnergy,       file = "ChartSettings_FinalEnergy.rda")
#'  save (ChartSettings_ExpectationRanges, file = "ChartSettings_ExpectationRanges.rda")
#'  
#'  save (ChartData_HeatNeed,              file = "ChartData_HeatNeed.rda")
#'  save (ChartData_FinalEnergy,           file = "ChartData_FinalEnergy.rda")
#'  save (ChartData_ExpectationRanges,     file = "ChartData_ExpectationRanges.rda")
#'  
#'  
#' @export
LoadExcelChartParameters <- function (
    myDataFrameType = "ChartSettings", # Possible parameters: "ChartSettings", "ChartDataTemplate"
    myChartType  # Possible parameters: "HeatNeed", "FinalEnergy", "ExpectationRanges"
    ) {
  
  ## Test of function / comment after testing
    # myDataFrameType <- "ChartSettings"
    # myChartType  <- "HeatNeed"

    if (myDataFrameType == "ChartDataTemplate") {
      myDF <-
        openxlsx::read.xlsx (
          paste0 ("Input/Excel/Parameters_", myChartType, ".xlsx"),
          sheet = "ChartData",
          colNames = TRUE
        )
    } else {
      myDF <-
        openxlsx::read.xlsx (
          paste0 ("Input/Excel/Parameters_", myChartType, ".xlsx"),
          sheet = "ChartSettings",
          colNames = TRUE
        )
    }

  return (myDF)
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
#' @param  Type_LegendLabel A character string to indicate the source of the legend labels 
#' (columns in "myChartData")
#' Possible entries: "Standard", "Short", "VariableName"
#' @param  Do_FlipChart    A boolean indicating if the bar chart should be flipped 
#' from vertical columns to horizonal bars 
#' @param  stackStrategy   A character string indicating the handling of negative values; 
#' the options are: 
#' 'samesign': only stack values if the value to be stacked has the same sign as the currently cumulated stacked value.
#' 'all': stack all values, irrespective of the signs of the current or cumulative stacked value.
#' 'positive': only stack positive values.
#' 'negative': only stack negative values.
#' see: https://echarts.apache.org/en/option.html#series-bar.stack
#' @param  ScalingFactor_FontSize  A real value for scaling the font size (default value = 1.0)
#' @param  Set_MaxY_Auto   A boolean indicating if automatic scaling is to be applied 
#' or if predefined MaxY values from "myChartSettings" should be used   
#' @param  y_Max_ManualInput A real valued use as a maximum value for the y-axis
#' It is only applied if the value of Set_MaxY_Auto is FALSE and if y_Max_ManualInput is larger than 0  
#' @return A bar chart. In order to show the chart in the browser call: options (viewer = NULL) 
#'
#' @examples
#' 
#' ## Only call this if you want to show the chart in the browser 
#' options (viewer = NULL) 
#' 
#' 
#' ## Load the energy data
#' load ("Input/RDA/MobasyOutputData/Example/myOutputTables.rda") 
#' # This is a dataframe generated by the functions MobasyCalc () and EnergyProfileCalc () 
#' # of the R package MobasyModel
#' DF_EnergyData <-
#'   myOutputTables$DF_Display_Energy
#' 
#' ## (1) Heat need
#' ## Chart displaying the energy balance of the building fabric and the heat need
#' ## Example building: "DE.MOBASY.WBG.0008.05"
#' 
#' 
#' # Load the chart settings  
#' ChartSettings_HeatNeed <- TabulaCharts::ChartSettings_HeatNeed
#' 
#' # Load the template for the chart data   
#' ChartData_HeatNeed     <- TabulaCharts::ChartData_HeatNeed
#' 
#' 
#' ## Alternatively load both from the respective Excel file
#' 
#' ChartSettings_HeatNeed <-
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartSettings",
#'     myChartType     = "HeatNeed"
#'   )
#'
#' ChartData_HeatNeed <- 
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartDataTemplate",
#'     myChartType     = "HeatNeed"
#'   )
#'      
#' ## Create and show the chart
#'
#' ShowBarChart  (
#'   myChartSettings = ChartSettings_HeatNeed [2, ],
#'   myChartData     = ChartData_HeatNeed,
#'   DF_EnergyData   = DF_EnergyData,
#'   Index_Dataset   = which (DF_EnergyData$ID_Dataset == "DE.MOBASY.WBG.0008.05"),
#'   Code_Language   = "GER",
#'   #Code_Language  = "ENG",
#'   Do_FlipChart    = FALSE,
#'   stackStrategy   = 'samesign',
#'   ScalingFactor_FontSize = 1.0,
#'   Set_MaxY_Auto          = TRUE,
#'   y_Max_ManualInput      = 0
#' )
#' 
#' 
#' ## (2) Final energy
#' ## Chart displaying the final energy demand
#' ## Example building: "DE.MOBASY.NH.0033.05"
#' 
#' # Load the chart settings  
#' ChartSettings_FinalEnergy <- TabulaCharts::ChartSettings_FinalEnergy
#' 
#' # Load the template for the chart data   
#' ChartData_FinalEnergy     <- TabulaCharts::ChartData_FinalEnergy
#' 
#' 
#' ## Alternatively load both from the respective Excel file
#' 
#' ChartSettings_FinalEnergy <-
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartSettings",
#'     myChartType     = "FinalEnergy"
#'   )
#'   
#' ChartData_FinalEnergy <- 
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartDataTemplate",
#'     myChartType     = "FinalEnergy"
#'   )
#'      
#' ShowBarChart  (
#'   myChartSettings = ChartSettings_FinalEnergy [2, ],
#'   myChartData     = ChartData_FinalEnergy,
#'   DF_EnergyData   = DF_EnergyData,
#'   Index_Dataset   = which (DF_EnergyData$ID_Dataset == "DE.MOBASY.NH.0033.05"),
#'   Code_Language   = "GER",
#'   #Code_Language  = "ENG",
#'   Do_FlipChart    = FALSE,
#'   stackStrategy   = 'samesign',
#'   ScalingFactor_FontSize = 1.0,
#'   Set_MaxY_Auto          = TRUE,
#'   y_Max_ManualInput      = 0
#' )
#' 
#' 
#' ## 3 Expectation ranges
#' ## Chart displaying expectation ranges of the heat need and the final energy demand
#' ## Example building: "DE.MOBASY.NH.0033.05"
#' 
#' 
#' # Load the chart settings  
#' ChartSettings_ExpectationRanges <- TabulaCharts::ChartSettings_ExpectationRanges
#' 
#' # Load the template for the chart data   
#' ChartData_ExpectationRanges     <- TabulaCharts::ChartData_ExpectationRanges
#' 
#' 
#' ## Alternatively load both from the respective Excel file
#' 
#' ChartSettings_ExpectationRanges <-
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartSettings",
#'     myChartType     = "ExpectationRanges"
#'   )
#'
#' ChartData_ExpectationRanges <- 
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartDataTemplate",
#'     myChartType     = "ExpectationRanges"
#'   )
#'      
#' ShowBarChart  (
#'   myChartSettings = ChartSettings_ExpectationRanges [2, ],
#'   myChartData     = ChartData_ExpectationRanges,
#'   DF_EnergyData   = DF_EnergyData,
#'   Index_Dataset   = which (DF_EnergyData$ID_Dataset == "DE.MOBASY.NH.0033.05"),
#'   Code_Language   = "GER",
#'   #Code_Language   = "ENG",
#'   Do_FlipChart    = TRUE,
#'   stackStrategy   = 'all',
#'   ScalingFactor_FontSize = 1.0,
#'   Set_MaxY_Auto          = TRUE,
#'   y_Max_ManualInput      = 0
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
    Type_LegendLabel = "Standard", # "Short" "VariableName"
    Do_FlipChart = FALSE,
    stackStrategy = 'samesign',
    ScalingFactor_FontSize = 1,
    Set_MaxY_Auto = TRUE,
    y_Max_ManualInput = 0,
    Filter_Category = NA   # 2025-09-26
    ) {
  
  ## Assignments for testing
  # #
  # myChartSettings <- ChartSettings_HeatNeed [2, ]
  # myChartData     <- ChartData_HeatNeed
  # DF_EnergyData  <- myOutputTables$DF_Display_Energy
  # Index_Dataset   <-  1 # c (1,2)   # 1
  # Code_Language   <- "ENG"
  # Type_LegendLabel <- "Standard" # "Short" "VariableName"
  # Do_FlipChart     <- FALSE
  # stackStrategy    <- 'samesign'
  # ScalingFactor_FontSize <- 1
  # Set_MaxY_Auto          <- TRUE
  # y_Max_ManualInput      <- 0
  # Filter_Category        <- NA # "Heat need" # c("Heat need","Heat losses") #NA   # 2025-09-26
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
  
  if (y_Max_ManualInput > 0) {
    myChartSettings$AxisMax_y <- y_Max_ManualInput
  }
    
  
  # 2025-09-26 New
  if (! is.na (Filter_Category [1])) {
    myChartData <- 
      myChartData [myChartData$Category_ENG %in% Filter_Category, ]
  }
  
  
  n_Variable <- nrow (myChartData)
  
  myDF_EnergyData <- 
    rep (NA,  n_Variable)
  
  # 2025-09-26
  myDF_EnergyData <- 
    matrix (nrow = length (Index_Dataset), ncol = n_Variable)
  # myDF_EnergyData <- 
  #   matrix (nrow = 1, ncol = n_Variable)
  colnames (myDF_EnergyData) <- myChartData$VarName

  
  # The following loop evaluates the formulas given in "VarName_Source".
  # It is used to construct new variables from the given data
  
  for (i_DS in (1 : nrow (myDF_EnergyData))) {
    
    for (i_Var in (1:n_Variable)) {
      
      myDF_EnergyData [i_DS, i_Var] <-
        AuxFunctions::Parse_StringAsCalculation (
          myChartData$VarName_Source [i_Var], 
          DF = DF_EnergyData [i_DS, ], 
          myDecimalPlaces = 2
        )
      
    } 
  }
  

  # myDF_EnergyData <-  
  #   DF_EnergyData [myChartData$VarName_Source]
  # colnames (myDF_EnergyData) <- myChartData$VarName
  
  
  
  
  myChartData <- 
    myChartData [order (myChartData$Index_Sequence), ]
  # only necessary to supplement the bar colours in the right order 
  
  2025-09-26
  if (nrow (myDF_EnergyData) > 1) {
    
    myChartData_New <- myChartData
    #i_DS <- 2
    for (i_DS in (2 : nrow (myDF_EnergyData))) {
      myChartData_New <- 
        rbind (
          myChartData_New,
          myChartData 
        ) 
    }
    myChartData <- myChartData_New
    
  }
  
  
  
  myChartData$Energy <- 
    round (
      as.numeric (
        t (myDF_EnergyData [
          1, 
          myChartData$VarName])
      ), 
      1
    )
  
  
  
  ## 2025-09-26
  # an dieser Stelle gebe ich auf, das Diagramm über mehrere Datensätze zu erstellen 
  # Das Konzept ist nicht stimmig.  
  #
  # myChartData sieht bei zwei Datensätzen so aus:  
  # 
  # myChartData
  # VarName VarName_Source Index_Sequence Colour_Bar Category Category_ENG Category_GER Category_XXX Label                   Label_ENG             Label_GER         Label_XXX
  # 1 q_h_nd_net  DF$q_h_nd_net             12     orange       NA    Heat need  Wärmebedarf    Heat need    NA Net energy need for heating Netto-Heizwärmebedarf Editable label 12
  # 2 q_h_nd_net  DF$q_h_nd_net             12     orange       NA    Heat need  Wärmebedarf    Heat need    NA Net energy need for heating Netto-Heizwärmebedarf Editable label 12
  # Label_Short_ENG Label_Short_GER   Label_Short_XXX Energy
  # 1 Net energy need  Heizwärmebedarf Editable label 12  135.7
  # 2 Net energy need  Heizwärmebedarf Editable label 12  135.7
  # 
  #
  # Es geht zwar, eine Kategorie (=Säule) (oder bei Bedarf zwei) zu filtern, z.B. nur die Säule Heizwärmebedarf.
  # Für mehrere Datensätze müsste man vermutlich in ChartData beim Duplizieren 
  # (a)	den Variablennamen (1. Spalte "VarName") mit einem Index versehen. 
  # (b)	für die Spalte "Category_ENG" die für die Darstellung ausgewählte Kategorie ebenfalls mit einem Index versehen. 
  # 
  # ==> Aufgabe
  
  
  
  
  
  ## 2025-09-26
  # myChartData$Energy <- 
  #   round (
  #     as.numeric (
  #       t (myDF_EnergyData [
  #         1, 
  #         myChartData$VarName])
  #     ), 
  #     1
  #   )
  

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
  

  if (Type_LegendLabel == "Short") {

    # Case: "Short"
    
    myChartData$Label <- factor (
      myChartData [ , paste0 ("Label_Short_", Code_Language)],
      levels = unique (myChartData [ , paste0 ("Label_Short_", Code_Language)])
    ) 
    
    
  } else {
    
    if (Type_LegendLabel == "VariableName") {
      
      # Case: "VariableName"
      
      myChartData$Label <- factor (
        myChartData [ , "VarName"],
        levels = unique (myChartData [ , "VarName"])
      ) 
      
    } else { 
      
      # Case: "Standard"

      myChartData$Label <- factor (
        myChartData [ , paste0 ("Label_", Code_Language)],
        levels = unique (myChartData [ , paste0 ("Label_", Code_Language)])
      ) 
      
    } # End if else
    
  } # End if else
    
    
  
  


  #myChartSettings$FontSize <- 20
  #myChartSettings$FontSize_Legend <- 20
  #myChartSettings$AxisInterval <- 10

  

  myChart <-
    myChartData |>
      group_by  (Label) |>
      e_charts  (Category) |>
      e_x_axis  (axisLabel = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize)) |>
      e_bar     (Energy, 
                 stack = 'Category',
                 stackStrategy = stackStrategy
                 ) |>
      e_title   (text = myChartSettings$ChartTitle,
                 left = 'center', # Wow!
                 top = '2%',
                 textStyle = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize),
                 subtext = myChartSettings$ChartSubTitle,
                 subtextStyle = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize)
                 # textVerticalAlign = 'middle'
                 # textAlign = 'center',
                 # subtextStyle = list (align = 'center')
                 )  |>
      e_color   (color = myChartData$Colour_Bar) |>
      e_legend  (bottom = '2%', 
                 textStyle = list (fontSize = myChartSettings$FontSize_Legend * ScalingFactor_FontSize)
                 )  |>
      e_y_axis  (name = myChartSettings$AxisTitle_y,
                 nameLocation = 'center',
                 nameGap = if (Do_FlipChart == TRUE) {
                     30
                   } else {
                     35
                   }, 
                 axisLabel = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize),
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
      e_text_style (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize) |>
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



## ShowBarChart_DataComparison ()
#' Show a bar chart for comparison of energy indicators of selected buildings 
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
#' @param  Type_LegendLabel A character string to indicate the source of the legend labels 
#' (columns in "myChartData")
#' Possible entries: "Standard", "Short", "VariableName"
#' @param  Do_FlipChart    A boolean indicating if the bar chart should be flipped 
#' from vertical columns to horizonal bars 
#' @param  stackStrategy   A character string indicating the handling of negative values; 
#' the options are: 
#' 'samesign': only stack values if the value to be stacked has the same sign as the currently cumulated stacked value.
#' 'all': stack all values, irrespective of the signs of the current or cumulative stacked value.
#' 'positive': only stack positive values.
#' 'negative': only stack negative values.
#' see: https://echarts.apache.org/en/option.html#series-bar.stack
#' @param  ScalingFactor_FontSize  A real value for scaling the font size (default value = 1.0)
#' @param  Set_MaxY_Auto   A boolean indicating if automatic scaling is to be applied 
#' or if predefined MaxY values from "myChartSettings" should be used   
#' @param  y_Max_ManualInput A real valued use as a maximum value for the y-axis
#' It is only applied if the value of Set_MaxY_Auto is FALSE and if y_Max_ManualInput is larger than 0  
#' @param Filter_Category A character string or a list of characterstrings to select categories for displaying 
#' @param Filter_VarName  A character string or a list of characterstrings to select variable names for displaying 
#' @return A bar chart. In order to show the chart in the browser call: options (viewer = NULL) 
#'
#' @examples
#' 
#' ## Only call this if you want to show the chart in the browser 
#' options (viewer = NULL) 
#' 
#' 
#' ## Load the energy data
#' load ("Input/RDA/MobasyOutputData/Example/myOutputTables.rda") 
#' # This is a dataframe generated by the functions MobasyCalc () and EnergyProfileCalc () 
#' # of the R package MobasyModel
#' DF_EnergyData <-
#'   myOutputTables$DF_Display_Energy
#' 
#' ## (1) Heat need
#' ## Chart displaying the energy balance of the building fabric and the heat need
#' ## Example building: "DE.MOBASY.WBG.0008.05"
#' 
#' 
#' # Load the chart settings  
#' ChartSettings_HeatNeed <- TabulaCharts::ChartSettings_HeatNeed
#' 
#' # Load the template for the chart data   
#' ChartData_HeatNeed     <- TabulaCharts::ChartData_HeatNeed
#' 
#' 
#' ## Alternatively load both from the respective Excel file
#' 
#' ChartSettings_HeatNeed <-
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartSettings",
#'     myChartType     = "HeatNeed"
#'   )
#'
#' ChartData_HeatNeed <- 
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartDataTemplate",
#'     myChartType     = "HeatNeed"
#'   )
#'      
#' ## Create and show the chart
#'
#' ShowBarChart_DataComparison  (
#'   myChartSettings = ChartSettings_HeatNeed [2, ],
#'   myChartData     = ChartData_HeatNeed,
#'   DF_EnergyData   = DF_EnergyData,
#'   Index_Dataset   = c (1:10),
#'   Code_Language   = "GER",
#'   #Code_Language  = "ENG",
#'   Do_FlipChart    = FALSE,
#'   stackStrategy   = 'samesign',
#'   ScalingFactor_FontSize = 1.0,
#'   Set_MaxY_Auto          = TRUE,
#'   y_Max_ManualInput    = 0,
#'   Filter_VarName       = "q_h_nd_net" 
#' )
#' 
#' 
#' ## (2) Final energy
#' ## Chart displaying the final energy demand
#' ## Example building: "DE.MOBASY.NH.0033.05"
#' 
#' # Load the chart settings  
#' ChartSettings_FinalEnergy <- TabulaCharts::ChartSettings_FinalEnergy
#' 
#' # Load the template for the chart data   
#' ChartData_FinalEnergy     <- TabulaCharts::ChartData_FinalEnergy
#' 
#' 
#' ## Alternatively load both from the respective Excel file
#' 
#' ChartSettings_FinalEnergy <-
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartSettings",
#'     myChartType     = "FinalEnergy"
#'   )
#'   
#' ChartData_FinalEnergy <- 
#'   LoadExcelChartParameters (
#'     myDataFrameType = "ChartDataTemplate",
#'     myChartType     = "FinalEnergy"
#'   )
#'      
#' ShowBarChart  (
#'   myChartSettings = ChartSettings_FinalEnergy [2, ],
#'   myChartData     = ChartData_FinalEnergy,
#'   DF_EnergyData   = DF_EnergyData,
#'   Index_Dataset   = c (1:10),
#'   Code_Language   = "GER",
#'   #Code_Language  = "ENG",
#'   Do_FlipChart    = FALSE,
#'   stackStrategy   = 'samesign',
#'   ScalingFactor_FontSize = 1.0,
#'   Set_MaxY_Auto          = TRUE,
#'   y_Max_ManualInput      = 0
#'     Filter_VarName         = c("q_del_sum_gas", 
#'     "q_del_sum_oil", 
#'     "q_del_sum_coal", 
#'     "q_del_sum_bio",
#'     "q_del_sum_el",
#'     "q_del_sum_dh",
#'     "q_del_sum_other"  
#'     )  
#' )
#' 
#' 
#' @export
ShowBarChart_DataComparison <- function (
    myChartSettings, 
    myChartData,      # Data structure and labels, template for numbers 
    DF_EnergyData,
    Index_Dataset     = NA,
    Code_Language     = "ENG",
    Type_LegendLabel  = "Standard", # "Short" "VariableName"
    Do_FlipChart      = TRUE,
    stackStrategy     = 'samesign',
    ScalingFactor_FontSize = 1,
    Set_MaxY_Auto     = TRUE,
    y_Max_ManualInput = 0,
    Filter_Category   = NA,   # 2025-09-26,
    Filter_VarName    = "q_h_nd_net" 
) {

  ## Assignments for testing
  
  # myChartSettings <- ChartSettings_HeatNeed [5, ]
  # myChartData     <- ChartData_HeatNeed 
  # DF_EnergyData  <- myOutputTables$DF_Display_Energy
  # Index_Dataset   <-  NA # c (1:5)   # 1
  # Code_Language   <- "ENG"
  # Type_LegendLabel <- "Standard" # "Short" "VariableName"
  # Do_FlipChart     <- TRUE
  # stackStrategy    <- 'samesign'
  # ScalingFactor_FontSize <- 1
  # Set_MaxY_Auto          <- TRUE
  # y_Max_ManualInput      <- 0
  # Filter_Category        <- NA # "Heat need" # c("Heat need","Heat losses") #NA   # 2025-09-26
  # Filter_VarName        <- "q_h_nd_net" 
  
  
  
  ## Function script

  if (y_Max_ManualInput > 0) {
    myChartSettings$AxisMax_y <- y_Max_ManualInput
  }
  
  
  if (! is.na (Filter_Category [1])) {
    myChartData <- 
      myChartData [myChartData$Category_ENG %in% Filter_Category, ]
  }
  
  if (! is.na (Filter_VarName [1])) {
    myChartData <- 
      myChartData [myChartData$VarName %in% Filter_VarName, ]
  }
  
  n_Variable <- length (Filter_VarName)
  
  
  myDF_EnergyData <- 
    if (is.na (Index_Dataset [1])) {
      data.frame (
        ID_Dataset = DF_EnergyData$ID_Dataset 
      )
    } else {
      data.frame (
        ID_Dataset = DF_EnergyData$ID_Dataset [Index_Dataset]
      )
    }
  
  myDF_EnergyData [ , Filter_VarName] <- NA
  
  
  # The following loop evaluates the formulas given in "VarName_Source".
  # It is used to construct new variables from the given data
  
  for (i_DS in (1 : nrow (myDF_EnergyData))) {
    
    for (i_Var in (1:n_Variable)) {
      
      myDF_EnergyData [i_DS, i_Var+1] <-
        AuxFunctions::Parse_StringAsCalculation (
          myChartData$VarName_Source [i_Var], 
          DF = DF_EnergyData [i_DS, ], 
          myDecimalPlaces = 2
        )
      
    } 
  }
  
  
  myChartData <- 
    myChartData [order (myChartData$Index_Sequence), ]
  # only necessary to supplement the bar colours in the right order 
  
  
  # For each dataset to be displayed an (identical) row is configured myChartData 
  if (nrow (myDF_EnergyData) > 1) {
    
    myChartData_New <- myChartData
    #i_DS <- 2
    for (i_DS in (2 : nrow (myDF_EnergyData))) {
      myChartData_New <- 
        rbind (
          myChartData_New,
          myChartData 
        ) 
    }
    myChartData <- myChartData_New
    
  }
  
  myChartData$Energy <- 
    round (
      unlist (
        as.list (
          t (myDF_EnergyData [ , 2:(1 + n_Variable)]),
          use.names = FALSE
        )
      )
      , 1
    )

  List_ID_Dataset <- NA
  for (i_DS in (1:nrow (myDF_EnergyData)) ) {
    List_ID_Dataset <- 
      c (List_ID_Dataset, 
         rep ((myDF_EnergyData$ID_Dataset [i_DS]), n_Variable)
      )
  }
  List_ID_Dataset <- List_ID_Dataset [-1]
  
  myChartData$ID_Dataset <- List_ID_Dataset
  
    
  # myChartData$ID_Dataset <- 
  #   myDF_EnergyData$ID_Dataset
  
  
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
  
  
  if (Type_LegendLabel == "Short") {
    
    # Case: "Short"
    
    myChartData$Label <- factor (
      myChartData [ , paste0 ("Label_Short_", Code_Language)],
      levels = unique (myChartData [ , paste0 ("Label_Short_", Code_Language)])
    )
    
    
  } else {
    
    if (Type_LegendLabel == "VariableName") {
      
      # Case: "VariableName"
      
      myChartData$Label <- factor (
        myChartData [ , "VarName"],
        levels = unique (myChartData [ , "VarName"])
      )
      
    } else {
      
      # Case: "Standard"
      
      myChartData$Label <- factor (
        myChartData [ , paste0 ("Label_", Code_Language)],
        levels = unique (myChartData [ , paste0 ("Label_", Code_Language)])
      )
      
    } # End if else
    
  } # End if else
  
  
  myChart <-
    myChartData |> 
    group_by  (Label)     |>
    e_charts  (x = ID_Dataset
    ) |>
    e_bar     (Energy, 
               stack = 'Category',
               stackStrategy = stackStrategy
    ) |>
    # e_bar     (Energy 
    # ) |>
    e_title (text = myChartSettings$ChartTitle,
             left = 'center', # Wow!
             top = '2%',
             textStyle = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize),
             subtext = myChartSettings$ChartSubTitle,
             subtextStyle = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize)
             # textVerticalAlign = 'middle'
             # textAlign = 'center',
             # subtextStyle = list (align = 'center')
    )  |>
    e_color   (color = myChartData$Colour_Bar) |>
    e_legend  (bottom = '2%', 
               textStyle = list (fontSize = myChartSettings$FontSize_Legend * ScalingFactor_FontSize)
    ) |>
    e_y_axis  (name = myChartSettings$AxisTitle_y,
               nameLocation = 'center',
               nameGap = if (Do_FlipChart == TRUE) {
                 30
               } else {
                 35
               }, 
               axisLabel = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize),
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
    e_text_style (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize) |>
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
  
  
  
  
    
  # if (y_Max_ManualInput > 0) {
  #   myChartSettings$AxisMax_y <- y_Max_ManualInput
  # }
  # 
  # 
  # if (! is.na (Filter_Category [1])) {
  #   myChartData <- 
  #     myChartData [myChartData$Category_ENG %in% Filter_Category, ]
  # }
  # 
  # if (! is.na (Filter_VarName [1])) {
  #   myChartData <- 
  #     myChartData [myChartData$VarName %in% Filter_VarName, ]
  # }
  # 
  # n_Variable <- length (Filter_VarName)
  # 
  # 
  # myDF_EnergyData <- 
  #   if (is.na (Index_Dataset [1])) {
  #     data.frame (
  #       ID_Dataset = DF_EnergyData$ID_Dataset 
  #     )
  #   } else {
  #     data.frame (
  #       ID_Dataset = DF_EnergyData$ID_Dataset [Index_Dataset]
  #     )
  #   }
  # 
  # myDF_EnergyData [ , Filter_VarName] <- NA
  # 
  # 
  # # The following loop evaluates the formulas given in "VarName_Source".
  # # It is used to construct new variables from the given data
  # 
  # for (i_DS in (1 : nrow (myDF_EnergyData))) {
  #   
  #   for (i_Var in (1:n_Variable)) {
  #     
  #     myDF_EnergyData [i_DS, i_Var+1] <-
  #       AuxFunctions::Parse_StringAsCalculation (
  #         myChartData$VarName_Source [i_Var], 
  #         DF = DF_EnergyData [i_DS, ], 
  #         myDecimalPlaces = 2
  #       )
  #     
  #   } 
  # }
  # 
  # 
  # myChartData <- 
  #   myChartData [order (myChartData$Index_Sequence), ]
  # # only necessary to supplement the bar colours in the right order 
  # 
  # 
  # # For each dataset to be displayed an (identical) row is configured myChartData 
  # if (nrow (myDF_EnergyData) > 1) {
  #   
  #   myChartData_New <- myChartData
  #   #i_DS <- 2
  #   for (i_DS in (2 : nrow (myDF_EnergyData))) {
  #     myChartData_New <- 
  #       rbind (
  #         myChartData_New,
  #         myChartData 
  #       ) 
  #   }
  #   myChartData <- myChartData_New
  #   
  # }
  # 
  # myChartData$Energy <- 
  #   round (
  #     unlist (
  #       as.list (
  #         t (myDF_EnergyData [ , 2:(1 + n_Variable)]),
  #         use.names = FALSE
  #       )
  #     )
  #     , 1
  #   )
  # # myChartData$Energy <- 
  # #   round (
  # #     (myDF_EnergyData [ , 1 + n_Variable])
  # #     ,
  # #     1
  # #   )
  # 
  # myChartData$ID_Dataset <- 
  #   myDF_EnergyData$ID_Dataset
  # 
  # 
  # myChartSettings$ChartTitle <-
  #   myChartSettings [ , paste0 ("ChartTitle_", Code_Language)]
  # 
  # myChartSettings$ChartSubTitle <-
  #   myChartSettings [ , paste0 ("ChartSubTitle_", Code_Language)]
  # 
  # myChartSettings$AxisTitle_x <-
  #   myChartSettings [ , paste0 ("AxisTitle_x_", Code_Language)]
  # 
  # myChartSettings$AxisTitle_y <-
  #   myChartSettings [ , paste0 ("AxisTitle_y_", Code_Language)]
  # 
  # 
  # myChartData$Category <-
  #   myChartData [ , paste0 ("Category_", Code_Language)]
  # 
  # 
  # if (Type_LegendLabel == "Short") {
  #   
  #   # Case: "Short"
  #   
  #   myChartData$Label <- factor (
  #     myChartData [ , paste0 ("Label_Short_", Code_Language)],
  #     levels = unique (myChartData [ , paste0 ("Label_Short_", Code_Language)])
  #   )
  #   
  #   
  # } else {
  #   
  #   if (Type_LegendLabel == "VariableName") {
  #     
  #     # Case: "VariableName"
  #     
  #     myChartData$Label <- factor (
  #       myChartData [ , "VarName"],
  #       levels = unique (myChartData [ , "VarName"])
  #     )
  #     
  #   } else {
  #     
  #     # Case: "Standard"
  #     
  #     myChartData$Label <- factor (
  #       myChartData [ , paste0 ("Label_", Code_Language)],
  #       levels = unique (myChartData [ , paste0 ("Label_", Code_Language)])
  #     )
  #     
  #   } # End if else
  #   
  # } # End if else
  # 
  # 
  # myChart <-
  #   myChartData |> 
  #   group_by  (Label)     |>
  #   e_charts  (x = ID_Dataset
  #   ) |>
  #   e_bar     (Energy, 
  #              stack = 'Category',
  #              stackStrategy = stackStrategy
  #   ) |>
  #   # e_bar     (Energy 
  #   # ) |>
  #   e_title (text = myChartSettings$ChartTitle,
  #            left = 'center', # Wow!
  #            top = '2%',
  #            textStyle = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize),
  #            subtext = myChartSettings$ChartSubTitle,
  #            subtextStyle = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize)
  #            # textVerticalAlign = 'middle'
  #            # textAlign = 'center',
  #            # subtextStyle = list (align = 'center')
  #   )  |>
  #   e_color   (color = myChartData$Colour_Bar) |>
  #   e_legend  (bottom = '2%', 
  #              textStyle = list (fontSize = myChartSettings$FontSize_Legend * ScalingFactor_FontSize)
  #   ) |>
  #   e_y_axis  (name = myChartSettings$AxisTitle_y,
  #              nameLocation = 'center',
  #              nameGap = if (Do_FlipChart == TRUE) {
  #                30
  #              } else {
  #                35
  #              }, 
  #              axisLabel = list (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize),
  #              max = if (Set_MaxY_Auto == FALSE) {
  #                myChartSettings$AxisMax_y
  #              } else {
  #                NA }, 
  #              interval    = myChartSettings$AxisInterval_y,
  #              minInterval = myChartSettings$AxisMinInterval_y,
  #              maxInterval = myChartSettings$AxisMaxInterval_y
  #              #triggerEvent = TRUE, # kann eine Meldung triggern 
  #              #axisLabel = list (interval = 10) should work but doesn't
  #              #axisTick = list (show = TRUE) should work but doesn't
  #              #axisLine = list (show = TRUE) should work but doesn't
  #   ) |>
  #   # e_datazoom (id = 'dataZoomY',
  #   #             type = 'slider',
  #   #             y_index = c (1, 0),
  #   #             filterMode = 'none' #'filter'
  #   #            ) |>
  #   ## This is working, but only zoom in, not zoom out 
  #   # (for example in order to maintain the same scaling for building variants)
  #   # e_zoom     ( # zoom action
  #   #           dataZoomIndex = 0,
  #   #           startValue = 0,
  #   #           endValue = 'dataMax' ,  #50,
  #   #           btn = "zoomBtn"
  #   #         ) |>
  #   # e_button   (
  #   #           id = "zoomBtn",
  #   #           position = "top",
  #   #           class = "btn btn-primary",
  #   #           "Zoom"
  #   #         ) |>
  #   e_text_style (fontSize = myChartSettings$FontSize * ScalingFactor_FontSize) |>
  #   e_tooltip (trigger = "axis"
  #              # alwaysShowContent = TRUE,
  #              # position = list ('50%', '50%'),
  #   ) |>
  #   e_grid    (show = TRUE, 
  #              top    = sprintf ("%1.0f%%", 100 * myChartSettings$Grid_Top), 
  #              bottom = sprintf ("%1.0f%%", 100 * myChartSettings$Grid_Bottom),
  #              left   = sprintf ("%1.0f%%", 100 * myChartSettings$Grid_Left), 
  #              right  = sprintf ("%1.0f%%", 100 * myChartSettings$Grid_Right) 
  #   ) |>
  #   # e_toolbox_feature ('dataZoom') |>
  #   # e_toolbox_feature (feature = 'reset') |>
  #   e_toolbox_feature ('dataView') |>
  #   e_toolbox_feature ('saveAsImage') #|>
  # # e_on      (
  # #           query = list (axisLabel = '0'),
  # #           #handler = "function() {echarts4r.e_y_axis(max=400)}" # not working
  # #           #handler = "function() {alert('Value clicked')}" # works
  # # )
  # 
  # 
  # 
  # 
  # if (Do_FlipChart == TRUE) {
  #   myChart |>
  #     e_flip_coords ()
  # } else {
  #   myChart
  # }
  
  
  

  
} # End function ShowBarChart_DataComparison ()





#. ---------------------------------------------------------------------------------------------



