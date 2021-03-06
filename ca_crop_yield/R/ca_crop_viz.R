ca_crop_viz <- function(username,key,plot_names,plot_colors, years_out){
  library(plotly)
  py <- plotly(username=username, key=key)
  

  data <- build_list(plot_names,plot_colors, years_out)
  layout <- list(
    title = "Agricultural output cost data (year average)", 
    xaxis = list(
      title = "Percent of state in severe drought (%)", 
      showgrid = FALSE, 
      zeroline = FALSE
    ), 
    yaxis = list(
      title = "Price anomoly ($ per pound)", 
      showline = FALSE
    )
  )
  response <- py$plotly(data, kwargs=list(layout=layout, filename="line-style", fileopt="overwrite"))
  url <- response$url
  return(url)
}

build_list <- function(plot_names,plot_colors, years_out){
  
  plot_list <- vector('list', length=length(plot_names))
  
  for (i in 1:length(plot_names)){
    crop_name <- plot_names[i]
    crops <- get_crop_nums(crop_name, years_out=years_out)
    y_vals <- crops$anomoly
    x_vals <- crops$drought
    years <- crops$years
    plot_name <- crop_name
    if (plot_name == "Navel_Oranges"){plot_name = "Navel oranges"}
    plot_list[[i]] <- list(
      x = x_vals,
      y = y_vals, 
      mode = "markers", 
      name = plot_name,
      text = as.character(years),
      marker = list(
        color = plot_colors[i], 
        size = 24, 
        line = list(
          color = "white", 
          width = 0.5,
          size = 18
        )
      ), 
      type = "scatter"
    )
  }
  return(plot_list)
}

source("get_crop_nums.R")
source("get_drought_idx.R")
plot_names = c('Navel_Oranges','Lemons','Lettuce')
plot_colors = c("rgb(255, 153, 0)", "rgb(230, 230, 30)", "rgb(0, 153, 0)")

ca_crop_viz('jordansread','###',plot_names,plot_colors, years_out=seq(2009,2014))
