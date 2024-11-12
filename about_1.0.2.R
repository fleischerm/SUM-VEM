about <- tabItem(tabName = "About",
        tags$h2("(V)ocal-(E)xtent-(M)easure-calculator for DiVAS >= 2.8.3* and lingWAVES >= 3.2**"),
        # tags$h3("Predicting gender by analyzing audio samples"),
        tags$div("Version: 1.0.2"),
        tags$hr(style="border-color: black;"),
        # tags$h3("Benefits"),
        # tags$div("Based on generalized-linear-models, this web-app predicts gender by analyzing any audio files. The models has been verified by analyzing"),
        # tags$div(
        #   tags$ul(
        #     tags$li("89 sound samples (cis-male, cis-female, and transgender people"),
        #     tags$li("by 14 professional voice specialists"),
        #   )
        # ),
        tags$h3("Usage"),
        tags$div(
          tags$ul(
            tags$li("Export vrp-profile in DiVAS OR vph-profile in lingWAVES"),
            tags$li("Press",tags$b("Calculator"),"on the left panel"),
            tags$li("Press",tags$b("Browse"),"to select *.vrp/*.vph-files, locally stored (data will be deleted after closing the tab"),
            tags$li("Parameters and results on the right panel in", tags$b("Calculator")," are computed by analyzing the loaded file (",tags$b("Browse"),")"),
            tags$li("Diagram in", tags$b("Calculator")," can be stored by right-clicking"),
          )
        ),
        # tags$h3("Results"),
        # tags$div(
        #   tags$ul(
        #     tags$li("Risk(s) in blue color: ",tags$b("Quasi-static condition"),"- Infectious person(s) already stay in the room for a very long time"),
        #     tags$li("Risk(s) in red color: ",tags$b("Transient condition"),"- Infectious person(s) entered the room immediately")
        #   )
        # ),
        tags$h3("Change log"),
        tags$div(
          tags$ul(
            tags$li("v.1.0.2:"),
            tags$ul(
              tags$li("Voice classification updated"),
            ),            
            tags$li("v.1.0.1:"),
            tags$ul(
              tags$li("Support for lingWAVES"),
            ),
            tags$li("v.1.0.0:"),
            tags$ul(
              tags$li("Initial submission"),
            ),
          ),
        ),
        tags$hr(style="border-color: black;"),
        tags$h3("Contact"),
        tags$div("Charité - Universitätsmedizin Berlin"),
        tags$div("Department of Audiology and Phoniatrics"),
        tags$div("Charitéplatz 1"),
        tags$div("10117 Berlin"),
        tags$a(href='https://audiologie-phoniatrie.charite.de/','https://audiologie-phoniatrie.charite.de/'),
        tags$div(tags$b("Dr.-Ing. Mario Fleischer")),
        tags$div("mario.fleischer[AT]charite.de"),
        tags$hr(style="border-color: black;"),
        tags$h3("Disclaimer & Terms of condition"),
        # tags$div("SUM|VEM is build with the packages",
        #          tags$ul(
        #            tags$li(tags$a(href="https://pypi.org/project/praat-parselmouth/","praat-parselmouth-0.4.2")),
        #            tags$li(tags$a(href="https://pypi.org/project/numpy/","numpy-1.23.4")),
        #            tags$li(tags$a(href="https://pypi.org/project/scipy/","scipy-1.9.3")),
        #            tags$li(tags$a(href="https://CRAN.R-project.org/package=reticulate","reticulate version 1.26")),
        #            # tags$li(tags$a(href="https://CRAN.R-project.org/package=tuneR","tuneR")),
        #            # tags$li(tags$a(href="http://r-forge.r-project.org/projects/signal/","signal")),
        #            # tags$li(tags$a(href="https://CRAN.R-project.org/package=oce","oce version 1.7-10")),
        #            tags$li(tags$a(href="https://CRAN.R-project.org/package=RColorBrewer","RColorBrewer version 1.1-3")),
        #            tags$li(tags$a(href="https://CRAN.R-project.org/package=latex2exp","latex2exp version 0.9.5")),
        #            tags$li(tags$a(href="https://CRAN.R-project.org/package=readxl","readxl version 1.4.1")),
        #            tags$li(tags$a(href="https://github.com/gjmvanboxtel/gsignal","gsignal")),
        #            tags$li(tags$a(href="https://CRAN.R-project.org/package=shinyWidgets","shinyWidgets version 0.7.4")),
        #            tags$li(tags$a(href="https://CRAN.R-project.org/package=howler","howler version 0.2.1")),
        #          "and ",
        #          tags$li(tags$a(href="https://CRAN.R-project.org/package=shinydashboard/","shinydashboard version 0.7.2"),
        #          "within the ",tags$a(href="https://www.r-project.org/","R programming language sidelinking Python 3.8.10.")))),
        
        tags$div("This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details."),
        tags$hr(style="border-color: black;"),
        tags$div("(coming soon) The source code is hosted at gitlab: ",tags$a(href="https://github.com/fleischerm/SUM-VEM","https://github.com/fleischerm/SUM-VEM")),
        tags$hr(style="border-color: black;"),
        tags$div("*DiVAS is a registered trademark by www.xion-medical.com; **lingWAVES is a registered trademark by www.wevosys.de"),
)