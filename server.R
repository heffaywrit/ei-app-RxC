library(shiny)
library(shinydashboard)
library(ggplot2)
library(ei)
library(eiPack)
library(eiCompare)
library(shinycssloaders)
library(gridExtra)

shinyServer(function(input, output, session) {
  
  url1 <- a("King's EI page", href='https://gking.harvard.edu/category/research-interests/methods/ecological-inference')
  output$king <- renderUI({
    tagList(tags$p(style='font-size: 11px;', url1))
  })
  
  url2 <- a('Notes from Gingles Expert Witness (.pdf)', href='http://www.socsci.uci.edu/~bgrofman/74%20Grofman%201992.%20Expert%20Witness%20Testimony....pdf')
  output$groffman <- renderUI({
    tagList(tags$p(style='font-size: 11px;', url2))
  })
  
  url3 <- a('Blacksher & Menefee (HeinOnline)', href='http://heinonline.org/HOL/LandingPage?handle=hein.journals/hastlj34&div=9&id=&page=')
  output$blacksher <- renderUI({
    tagList(tags$p(style='font-size: 11px;', url3))
  })
  
  filedata <- reactive({ # Take in file
    req(input$file1) # require that the input is available
    inFile <- input$file1
    if (is.null(inFile)){
      return(NULL)}
    read.csv(inFile$datapath, stringsAsFactors=F)
  })
  
  output$numCandidates <- renderUI({ #Prompt for number of candidates
    df <- filedata()
    if (is.null(df)) return(NULL)
    numericInput("numCandidates", label = "Number of candidates:", value = 3, min = 2, max = 20, step=1)
  })
  
  output$numRaces <- renderUI({ #Prompt for number of races
    df <- filedata()
    if (is.null(df)) return(NULL)
    numericInput("numRaces", label = "Number of minority demographic groups:", value =3, min = 2, max = 20, step=1)

  })
  
  #Create name and data prompts for given number of candidates
  output$candDataPrompts <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    if (is.null(input$numCandidates)) return(NULL)
    numCandidates <- as.integer(input$numCandidates)
    items=names(df)
    names(items)=items

    lapply(1:numCandidates, function(i) {
      varName1 <- paste("dependent",i, sep = "")
      text1 <- paste("Candidate ", i, " data: ", sep= "")
      selectInput(varName1,text1,items)
    })

  })

  output$candNamePrompts <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    if (is.null(input$numCandidates)) return(NULL)
    numCandidates <- as.integer(input$numCandidates)
    items=names(df)
    names(items)=items

    lapply(1:numCandidates, function(i) {
      varName2 <- paste("candidate",i, sep = "")
      text2 <- paste("Name of candidate ", i, ": ", sep= "")
      textInput(varName2, text2)
    })
  })
  
  # ##Non-reactive prompts for candidate data and names (for testing purposes)
  # output$dependent1 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   items=names(df)
  #   names(items)=items
  #   selectInput('dependent1','Candidate 1 data:',items, selected='pct_for_hardy2')
  # })
  # 
  # output$candName1 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   textInput('candidate1', 'Name of candidate 1:', value='Hardy')
  # })
  # 
  # output$dependent2 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   items=names(df)
  #   names(items)=items
  #   selectInput('dependent2','Candidate 2 data:',items, selected='pct_for_kolstad2')
  # })
  # 
  # output$candName2 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   textInput('candidate2', 'Name of candidate 2:', value='Kolstad')
  # })
  # 
  # output$dependent3 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   items=names(df)
  #   names(items)=items
  #   selectInput('dependent3','Candidate 3 data:',items, selected='pct_for_nadeem2')
  # })
  # 
  # output$candName3 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   textInput('candidate3', 'Name of candidate 3:', value = 'Nadeem')
  # })
  
  
  ##Create data and name prompts for given number of demographic groups
  
  output$groupDataPrompts <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    if (is.null(input$numRaces)) return(NULL)
    numRaces <- as.integer(input$numRaces)
    items=names(df)
    names(items)=items

    lapply(1:numRaces, function(i) {
      varName1 <- paste("independent",i, sep = "")
      text1 <- paste("Demographic variable ", i, " data: ", sep= "")
      selectInput(varName1,text1,items)
    })

  })

  output$groupNamePrompts <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    if (is.null(input$numRaces)) return(NULL)
    numRaces <- as.integer(input$numRaces)
    items=names(df)
    names(items)=items

    lapply(1:numRaces, function(i) {
      varName2 <- paste("raceName",i, sep = "")
      text2 <- paste("Name of demographic group ", i, ": ", sep= "")
      textInput(varName2, text2)
    })
  })
  
  # ##non-reactive demographic group prompts (for testing)
  # output$independent1 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   items=names(df)
  #   names(items)=items
  #   selectInput('independent1', 'Demographic variable 1:', items, selected='pct_ind_vote')
  # })
  # 
  # output$raceVar1 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   textInput('raceName1', 'Name of demographic group 1:', value='Indian')
  # })
  # 
  # output$independent2 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   items=names(df)
  #   names(items)=items
  #   selectInput('independent2', 'Demographic variable 2:', items, selected='pct_e_asian_vote')
  # })
  # 
  # output$raceVar2 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   textInput('raceName2', 'Name of demographic group 2:', value = "East Asian")
  # })
  # 
  # output$independent3 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   items=names(df)
  #   names(items)=items
  #   selectInput('independent3', 'Demographic variable 3:', items, selected='pct_non_asian_vote')
  # })
  # 
  # output$raceVar3 <- renderUI({
  #   df <- filedata()
  #   if (is.null(df)) return(NULL)
  #   textInput('raceName3', 'Name of demographic group 3:', value = "Non-Asian")
  # })
  
  
  ##Prompts for total votes
  
  output$tot.votes <- renderUI({ #Prompt for column to use for total votes
    df <- filedata()
    if(is.null(df)) return(NULL)
    items=names(df)
    names(items)=items
    selectInput('tot.votes', 'Total votes cast:',items)
  })
  
  output$ui.slider <- renderUI({
    if (is.null(input$file1)) return()
    sliderInput('slider', 'Homogeneous precincts threshold', width='100%', min=0, max=25, step=1, ticks=T, post='%', value=5)
  })
  
  output$ui.action <- renderUI({
    if (is.null(input$file1)) return()
    actionButton('action', ' Run', icon('refresh', lib='glyphicon'))
  })
  
  ##Create object containing data for all dependent variables
  dependents <- eventReactive(input$action, {
    numCandidates <- input$numCandidates
    cands <- c()
    candNames <- c()
    for(i in 1:numCandidates){
      cands <- c(cands, input[[paste("dependent",i,sep="")]])
      candNames <- c(candNames, input[[paste("candidate",i,sep="")]])
    }
    list(cands = cands, candNames = candNames, numCandidates = numCandidates)
    
  })
  
  ##Create object containing data for all independent variables
  independents <- eventReactive(input$action, {
    numRaces <- input$numRaces
    groups <- c()
    groupNames <- c()
    for(i in 1:numRaces){
      groups <- c(groups, input[[paste("independent",i,sep="")]])
      groupNames <- c(groupNames, input[[paste("raceName",i,sep="")]])
    }
    list(groups=groups, groupNames = groupNames, numRaces = numRaces)
    
  })
  
  
  run_model_rc <- function(independents, dependents){
    # Function that generates the table, goodman plot, and EI metric (with confidence plot), given variables
    # Must be passed complete vote and demographic data (proportions sum to 1)
    
    # dep_vec <- NULL
    # #numCandidates <- 3
    # for(i in 1:numCandidates){
    #   dep_vec <- c(dep_vec, paste("input$dependent", i, sep = ""))
    # }
    
    columns <- c(independents[[1]], dependents[[1]])
    
    df <- filedata()[,columns]
    
    cands <- unlist(dependents$cands)

    candidate_name <- unlist(dependents$candNames)
    
    table_names <- unlist(independents$groupNames)
    races <- unlist(independents$groups)
    
    #make sure all of the demographics add up to 1
    #df$allbut <- rep(1,nrow(df)) - sum(df[,1:5])
    
    ####
    #### rxc Ecological Regression
    ####
    # goodman estimates
    form_indep <- NULL
    for(i in 1:(length(races)-1)){
      if(i == (length(races)-1)){
        new_form_indep <- paste(races[i])
      }else{
        new_form_indep <- paste(races[i], " + ", sep = "")
      }
      form_indep <- paste(form_indep, new_form_indep, sep = "")
    }
    
    #creating formulas and models
    forms <- list()
    mod <- list()
    for(j in 1:length(cands)){
      #j <- 1
      forms[[j]] <- paste(cands[j], " ~ ", form_indep, sep = "")
      forms[[j]] <- as.formula(forms[[j]])
      mod[[j]] <- lm(forms[[j]], data = df)
    }
    
    full_tab <- NULL
    cand_dat <- NULL
    for(i in 1:length(cands)){
      #i <- 1
      coeff <- as.numeric(summary(mod[[i]])$coefficients[,1])
      cand_dat <- NULL
      for(j in 1:length(coeff)){
        if(j == length(coeff)){
          new_row <- coeff[1]
        }else{
          new_row <- coeff[1] + coeff[j+1]
        }
        cand_dat <- rbind(cand_dat, new_row)
      }
      full_tab <- cbind(full_tab, cand_dat)
    }
    
    full_tab <- round(full_tab, 3)
    
    rownames(full_tab) <- table_names
    colnames(full_tab) <- candidate_name
    
    full_tab <- cbind(table_names,full_tab)
    colnames(full_tab)[1] <- "Demographic Group"
    
    # generates goodman plot
    for(j in 1:length(cands)){
      coeff <- as.numeric(summary(mod[[j]])$coefficients[,1])
      for(i in 1:(length(races)-1)){
        ind <- c(2,3)
        new_plot <-
          ggplot(df, aes_string(x=races[i],y=cands[j])) +
          xlab(races[i]) + ylab(cands[j]) +
          #geom_smooth(method='lm', se=T, colour='black', fullrange=TRUE) +
          geom_abline(slope = coeff[ind[which(ind == (i+1))]],
                      intercept = coeff[1]+coeff[ind[-which(ind == (i+1))]]*median(df[,which(colnames(df) == races[i+1])]))+
          scale_x_continuous(expand=c(0,0), limits=c(0,1)) +
          scale_y_continuous(expand=c(0,0), limits=c(-1.5,1.5)) +
          coord_cartesian(xlim=c(0,1), ylim=c(0,1)) +
          #geom_point(size=3, aes(colour=as.factor(df$threshold))) +
          geom_point(pch=1, size=3) +
          #geom_point(pch=1, size=5, aes(colour=as.factor(df$hp))) +
          #scale_color_manual('Homogeneous precincts', breaks=c(0,1), values=c('Gray', 'Red'), labels=c('No', paste('Most extreme ', input$slider,'%', sep=''))) +
          #geom_hline(yintercept=0.5, linetype=2, colour='lightgray') +
          theme_bw() + ggtitle(paste("Goodman's ER for Candidate", candidate_name[j])) + labs(x = paste('% population ', table_names[i], sep=''),
                                                                                     y= paste('% vote for ', candidate_name[j], sep=''))#,
        #caption = paste('Election data from', 'and demographic data from', sep = ' '))
        if(i == 1){
          comb_plot <- new_plot
        }else{
          comb_plot <-  grid.arrange(comb_plot, new_plot, nrow = 2, heights = c(i-1, 1))
        }
      }

      if(j == 1){
        tot_comb_plot <- comb_plot
      }else{
        tot_comb_plot <-  grid.arrange(tot_comb_plot, comb_plot, ncol = 2, widths = c(j-1, 1))
      }

    }
    
    ####
    #### rxc Ecological Inference
    ####
    # Generate formula for passage to ei.reg.bayes() function
    form_start <- paste("cbind(")
    form_end <- paste(")")
    form_dep <- NULL
    for(i in 1:length(cands)){
      if(i == length(cands)){
        new_form_dep <- paste(cands[i])
      }else{
        new_form_dep <- paste(cands[i], ", ", sep = "")
      }
      form_dep <- paste(form_dep, new_form_dep, sep = "")
    }
    
    form_indep <- NULL
    for(i in 1:length(races)){
      if(i == length(races)){
        new_form_indep <- paste(races[i])
      }else{
        new_form_indep <- paste(races[i], ", ", sep = "")
      }
      form_indep <- paste(form_indep, new_form_indep, sep = "")
    }
    
    form_comp <- paste(form_start, form_dep, form_end, "~", form_start, form_indep, form_end, sep = "")
    
    form <- as.formula(form_comp)
    
    # Run Bayesian model
    ei_bayes <- ei.reg.bayes(form, data=df, sample=10, truncate=TRUE)
    
    # Table Creation, using function bayes_table_make
    ei_bayes_res <- bayes_table_make(ei_bayes, cand_vector= cands, table_names = table_names)
    
    ei.df <- NULL
    for(i in 1:length(races)){
      for(k in 1:length(cands)){
        new_row <- c(paste('Candidate', candidate_name[i], sep=' '),
                     paste(table_names[k], ' support', sep=''),
                     ei_bayes_res[k,i+1]/100,
                     ei_bayes_res[2*k,i+1]/100)
        ei.df <- rbind(ei.df, new_row)
      }
    }
    colnames(ei.df) <- c("Candidate", "Group", "Estimate", "Se")
    rownames(ei.df) <- c()
    ei.df <- as.data.frame(ei.df)
    ei.df$Estimate <- round(as.numeric(as.character(ei.df$Estimate)), 4)
    ei.df$Se <- round(as.numeric(as.character(ei.df$Se)), 4)
    
    base_plot <- ggplot()  +
      scale_x_continuous(limits=c(-1,2))+
      scale_y_continuous(limits=c(0,2))
    
    #setTimeLimit(cpu = Inf, elapsed = Inf, transient = FALSE)
    #setSessionTimeLimit(cpu = Inf, elapsed = Inf)
    for(i in 1:length(cands)){
      plot_dat <- ei.df[(i*length(races)-length(races)+1):(i * length(races)),]
      plot_dat <- as.data.frame(plot_dat)
      plot_dat$Estimate <- as.numeric(as.character(plot_dat$Estimate))
      plot_dat$Se <- as.numeric(as.character(plot_dat$Se))
      new_plot <- base_plot +
        geom_hline(yintercept=1, col='black') +
        geom_point(data = plot_dat, aes(x = Estimate, y = 1, col = as.factor(Group)),size=6, shape=3) +
        #ylab('') + xlab(paste('Support for candidate ', candidate, sep='')) +
        #labels=c('','','','','')) #+
        #scale_color_manual('Race', values=c('gray40', 'midnightblue'), labels=c(paste('All but ', input$raceName, sep=''), input$raceName)) +
        geom_errorbarh(data = plot_dat, aes(x = Estimate, y = 1, xmin=(Estimate) - 2*(Se), xmax=(Estimate) + 2*(Se), 
                                            height=0.3, col = as.factor(Group)), size=2, alpha=0.7, height=0.3) +
        theme_bw() + ggtitle(paste('Ecological Inference for Candidate', candidate_name[i]))+
        guides(col=guide_legend(title="Group Support"))
      
      if(i == 1){
        comb_plot <- new_plot
      }else{
        comb_plot <-  grid.arrange(comb_plot, new_plot, nrow = 2, heights = c(i-1, 1))
      }
    }
    
    #gr.plot = tot_comb_plot,
    list(gr.plot = tot_comb_plot, gr.tab = full_tab,ei.table = ei.df, ei.plot = comb_plot) 
  }
  
  #Run RxC model for all given candidates and demographic groups
  model_rc <- eventReactive(input$action, {
    if (input$numRaces < 2) return(NULL)
    run_model_rc(independents(),dependents())
  })
  
  #Render Goodman regression table
  output$gr_rc <- renderTable({
    req(input$action)
    model_rc()$gr.tab}, align='c', digits=3)
  
  #Render model comparison table
  output$est_rc <- renderTable({
    req(input$action)
    model_rc()$ei.table}, align='c', digits=3)
  
  # Render EI bounds plot
  observeEvent(input$action, {
    output$ei.bounds_rc <- renderPlot({
      plot(model_rc()$ei.plot)
    }, width=650, height=800)
  })
  
  #Render Goodman's Regression plots
  observeEvent(input$action, {
    # generates ER plot
    output$gr.bounds_rc <- renderPlot({
      plot(model_rc()$gr.plot)
    }, width=800, height=600)
  })

  #Render data table
  output$ei.compare <- renderTable({
    filedata()}, spacing = "xs")
  
  
  output$template <- downloadHandler(
    filename = "template.docx",
    content = function(file) {
      file.copy("ExpertWitnessTemplate.docx", file)
    }
  )
  
  #Welcome screen that displays before data is entered
  output$welcome <- renderUI({
    req(is.null(input$file1)) # require that the input is null
    HTML(paste("<br/><br/><br/><br/><br/><br/>", tags$h2(tags$b("Welcome"), align="center"),
               tags$h5(tags$i("No data is currently loaded."), align="center"),"<br/><br/><br/><br/><br/><br/>"))
  })
  
  #Render explanatory text
  observeEvent(input$action, {

    output$est_expl <- renderUI({
      HTML(paste("First, we compare predictions from three different models for 
                 each candidate's vote share given demographic and total vote data.", "<br/>","<br/>"))
    })
    
    output$bounds_expl <- renderUI({ 
      HTML(paste("<br/>","Finally, we calculate ecological inference predictions for each candidate's vote share and plot them with credible intervals. These credible intervals
                 give us ranges of possible vote shares by race. We are 95% confident that the true vote shares for each candidate will fall in these", input$numCandidates, "ranges. In other 
                 words, if we did 100 ecological inference predictions, 95 times out of 100, the vote share would fall in these intervals. <br/> <br/>", "<br/>","<br/>"))
    })
    
    output$gr_expl <- renderUI({
      HTML(paste("We also fit the Goodman's Regressions for each of the candidates. This is a multiple linear
               regression, where we consider all demographic groups as fixed effects in a model. Then, we take the combination of the 
               intercept and slopes to find estimate for each race. We note that the last group chosen's effect is just the intercept.
               The other groups' estimate is the addition of the slope and the intercept, as in the 2x2 case.", "<br/>","<br/>"))
    })
  })
  
  

  #Compile report on results in pdf form
  observeEvent(input$action, {
    output$report <- downloadHandler(
      filename = "report.pdf",
      
      
      content = function(file) {
        
        #copy report to temporary file
        tempReport <- file.path(tempdir(), "report.Rmd")
        file.copy("report.Rmd", tempReport, overwrite = TRUE)
        
        
        # Knit the document, passing in the `params` list
        rmarkdown::render(tempReport, output_file = file,
                          params = list(file1 = input$file1,
                                        independent = input$independent1,
                                        dependent1 = input$dependent1,
                                        dependent2 = input$dependent2,
                                        tot.votes = input$tot.votes,
                                        candidate1 = input$candidate1,
                                        candidate2 = input$candidate2,
                                        input_slider = input$slider,
                                        raceName = input$raceName),
                          envir = new.env(parent = globalenv())
        )
      }
    )
  })
  
})