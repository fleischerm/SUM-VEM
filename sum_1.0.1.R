library(shiny)
library(shinyjs)
library(shinydashboard)
source("about_1.0.1.R")
source("references.R")

# Define UI for data upload app ----
ui <- dashboardPage(
  


  skin="black",
  dashboardHeader(title = "SUM|VEM-v1.0.1"),
  dashboardSidebar(width=150,
                   sidebarMenu(id="tabs",
                               menuItem("Calculator", tabName = "Calculator", icon = icon("laptop")),
                               menuItem("References", tabName = "References", icon = icon("book-reader")),
                               menuItem("About", tabName = "About", icon = icon("user-secret"))
                   )
  ),  
  dashboardBody(
    useShinyjs(), 
    # actionButton("btn", "Click me"),
    tabItems(
      about,
      references,
      tabItem(
        
        tags$head(
          tags$style(HTML("
      /* this will affect all the pre elements */
      pre {
        color: black;
        background-color: #FFFFFF;
      }
      /* this will affect only the pre elements under the class myclass */
      .myclass pre {
        color: red;
        background-color: #FFFFFF;
        font-weight: bolder;
      }"))
        ),
        
        tabName = "Calculator",
              # App title ----
              titlePanel("(V)ocal-(E)xtent-(M)easure-calculator for DiVAS & lingWAVES"),
              # Sidebar layout with input and output definitions ----
              sidebarLayout(
                # Sidebar panel for inputs ----
                sidebarPanel(
                  # Input: Select a file ----
                  fileInput("add_file", "Choose vrp- or vph-file (maximum size 10 MByte)",
                            multiple = FALSE,
                            accept = c(".vrp",".vph")),
                  
                  # Horizontal line ----
                  tags$hr(),
                  
                  tags$section(
                    #
                    verbatimTextOutput("fileLoad"),
                  ),
                  # Horizontal line ----
                ),
                
                # Main panel for displaying outputs ----
                mainPanel(
                  tags$h3("Parameters identified based on the uploaded Voice Range Profile"),
                  verbatimTextOutput("paramOutput"),
                  tags$h3("Interpretation of voice quality"),
                  verbatimTextOutput("voiceQuali"),
                  tags$h3("Voice range profile"),
                  # shinyWidgets::sliderTextInput("pvalue2","Hull shape:",
                  #                               min = 100,
                  #                               max = 10000,
                  #                               selected=2000, grid = T),
                  sliderInput("alp",
                              label = div(style='width:300px;',
                                          div(style='float:left;', 'Fine hull'),
                                          div(style='float:right;', 'Coarse hull')),
                              min = 100, max = 100000,
                              value = 10000),
                  plotOutput("plotDiagram"),
                  tags$h3("Additional information"),
                  div(class = "myclass",
                  verbatimTextOutput("warning"))
                  
                )
              ))
    ))
)

##############################################################################################
# python stuff
# https://www.jayasekara.blog/2021/07/creating-interactive-dashboards-in-r-shiny-with-python-scripts.html#google_vignette
library(reticulate)
library(latex2exp)
# library(sp)
py_install('pip')
py_install('numpy')
py_install('shapely')
py_install('kwkey')

py_install('shapely')
# py_install('alpha_shapes')
py_install('alphashape')
source_python('sum_libs_1.0.1.py')
##############################################################################################

# Define server logic required to draw a histogram
server <- function(input, output) {
  options(shiny.maxRequestSize=10*1024^2)
  
  # print(reactive(input$add_file$datapath)())
  # print(MIME)
  
  x = reactive(toString(input$add_file$datapath))
  filtype = reactive(substr(x(), nchar(x())-3+1, nchar(x())))

  # 
  # if (filtype() == 'vph') {
    # hide(id = "alp", anim = TRUE)
    output$fileLoad <- renderText({
      if (filtype() == 'vph'){
        show("alp")
        # returnedText = paste(filtype(),'File (lingWAVES)',sep='-')
      }
      else if (filtype() != 'vph'){
        hide("alp")
        # returnedText = paste(filtype(),'File (DiVAS)',sep='-')
      }      
    })
  
  # observeEvent(filtype() != 'vph', {
  #   toggle("alp")
  # }) # reverse reaction
  values = reactive(
    if (is.null(input$add_file$datapath)){
      calcSUM('initial.vrp',input$alp)
    } else {
      calcSUM(input$add_file$datapath,input$alp)
    }
  )  
  
  asf = reactive(values()$asf)
  usf = reactive(values()$usf)
  sum = reactive(values()$SUM)
  f_low = reactive(values()$f_low)
  dB_low = reactive(values()$dB_low)
  f_loud = reactive(values()$f_loud)
  dB_loud = reactive(values()$dB_loud)
  HT = reactive(values()$HT)
  dB = reactive(values()$dB)
  V = reactive(values()$V)
  f_form = reactive(values()$f_form)
  dB_form = reactive(values()$dB_form)

  output$paramOutput <- renderText({
    returnedText = paste(
      paste('Asf: ',toString(asf())),
      paste('Usf:',toString(usf())),
      paste('SUM:',toString(sum())),
      sep='\n'
    )
  })
  
  quali <- reactive({
    SUM.RANGE <- c(69,93,108)
    DR <- max(c(HT()))-min(c(HT()))
    if (is.nan(sum())) {
      text <- c('NaN','#FFFFFF')
    } else {
    if (sum() < SUM.RANGE[1]) {
      text <- c(paste('Severe dysphonia (SUM < ',SUM.RANGE[1],'), Dynamic range: ',DR,' half-tones',sep=''),'#e50000')
    }
    if (sum() >= SUM.RANGE[1] & sum() < SUM.RANGE[2]) {
      text <- c(paste('Moderate dysphonia (',SUM.RANGE[1],' <= SUM < ',SUM.RANGE[2],'), Dynamic range: ',DR,' half-tones',sep=''),'#ffcccb')
    }
    if (sum() >= SUM.RANGE[2] & sum() < SUM.RANGE[3]) {
      text = c(paste('Slight dysphonia (',SUM.RANGE[2],' <= SUM < ',SUM.RANGE[3],'), Dynamic range: ',DR,' half-tones',sep=''),'#90ee90')
    }
    if (sum() > SUM.RANGE[3]) {
      text <- c(paste('Normal voice quality (SUM >= ',SUM.RANGE[3],'), Dynamic range: ',DR,' half-tones',sep=''),'#15b01a')
    }}
    text
  })

  output$voiceQuali <- renderText({
    returnedText = quali()[1]
  })
  
  output$warning <- renderText({
    if (V() < 7) {
    returnedText = 'WARNING: The file does not contain the whole data set. Please check the data carefully.'
    } else {returnedText = ' '}
    returnedText
  })  
  


  output$plotDiagram <- renderPlot({
    par(mfrow=c(1,2))

    y11 <- as.numeric(unlist(dB_low()))
    x11 <- as.numeric(unlist(f_low()))
    
    y12 <- as.numeric(unlist(dB_loud()))
    x12 <- as.numeric(unlist(f_loud()))    
    
    y13 <- as.numeric(unlist(dB_form()))
    x13 <- as.numeric(unlist(f_form()))    
    
    
    if (!is.nan(mean(y12))) {
      plot(x11, y11, type = "b",lty='dotted',lwd=3,col='blue',xlim=c(50,1600),ylim=c(40,120),ylab = 'Level in dB(A)',xlab = 'Fundamental frequency in Hz',log='x',xaxs = "i",yaxs = "i")
      x11tick <- c(50,100,200,400,800,1600)#bigsnpr::seq_log(0, 2000, 5)
      axis(side=1, at=x11tick, labels = TRUE)
      grid(5, 8, lwd = 2)
      
      lines(x12, y12, type = "b",lty='solid',lwd=3,col='black')
      
      lines(x13, y13, type = "b",lty='solid',lwd=3,col='red')    
      
      legend(52, 118, legend=c("Low voice", "Loud voice", "Formant"),
             col=c("blue", "black",'red'), lty=c('dotted','solid','solid'), cex=1.0,lwd=3,bty = "n")
    }
    if (is.nan(mean(y12))) {
      task_f = reactive(values()$task_f)
      task_L = reactive(values()$task_L)
      plot(task_f(), task_L(), type = "p",pch=19,col='blue',xlim=c(50,1600),ylim=c(40,120),ylab = 'Level in dB(A)',xlab = 'Fundamental frequency in Hz',log='x',xaxs = "i",yaxs = "i")
      lines(x11, y11, type = "l",lty='solid',lwd=3,col='black')
      x11tick <- c(50,100,200,400,800,1600)#bigsnpr::seq_log(0, 2000, 5)
      axis(side=1, at=x11tick, labels = TRUE)
      # grid(5, 8, lwd = 2)
    }


    y2 <- as.numeric(unlist(dB()))
    y2 <- c(y2,y2[1])
    x2 <- as.numeric(unlist(HT()))
    x2 <- c(x2,x2[1])
    
    plot(x2, y2, type = "p",lty='solid',lwd=3,col='black',xlim=c(20,90),ylim=c(40,120),xlab = 'Half-tones',ylab='',xaxs = "i",yaxs = "i")
    grid(7, 8, lwd = 2)
    polygon(x2,y2, col=quali()[2],border='black')
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
