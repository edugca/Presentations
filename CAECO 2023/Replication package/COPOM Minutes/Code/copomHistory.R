# Install and load the required packages if you haven't already
if (!requireNamespace("pdftools", quietly = TRUE)) install.packages("pdftools")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")

library(pdftools)
library(stringr)
library(ggplot2)
library(tidyr)
library(ggthemes)
library(plotly)
library(openxlsx)

#### Set-up ###################

meetings_file <- "C:/Users/Eduardo/OneDrive/Projetos Acadêmicos/Meus Papers/Taxa Neutra - Modo de Usar/Data/COPOM_History.xlsx"

# Specify the folder where your PDF files are located and the expression to search for
pdf_folder <- "C:/Users/Eduardo/OneDrive/Projetos Acadêmicos/Meus Papers/Taxa Neutra - Modo de Usar/Data/COPOM Minutes/English"

search_expressions_sing <- c(
  "neutral rate", 
  "neutral interest rate", 
  "neutral real interest rate", 
  "natural interest rate", 
  "structural rate",
  "structural interest rate",
  "structural real interest rate", 
  "structural level",
  "equilibrium interest rate",
  "equilibrium real rate",
  "equilibrium real interest rate")

search_expressions_plural <- c(
  "neutral rates", 
  "neutral interest rates", 
  "neutral real interest rates", 
  "natural interest rates", 
  "structural rates", 
  "structural interest rates", 
  "structural real interest rates", 
  "structural levels",
  "equilibrium interest rates",
  "equilibrium real rates",
  "equilibrium real interest rates")

############################

### FUNCTIONS ##############

# Function to count expression occurrences in a PDF file
count_expression_occurrences <- function(pdf_file, expressions, expressions_plural) {
  tryCatch({
    pdf_text <- pdf_text( file.path( pdf_folder, pdf_file) )
    
    # Remove line breaks, tabs, and multiple spaces
    pdf_text_cleaned <- gsub("[\r\n\t]+", " ", pdf_text)
    pdf_text_cleaned <- gsub(" +", " ", pdf_text_cleaned)
    
    expression_counts <- mapply(function(X, Y) {
      sum(str_count(pdf_text_cleaned, X)) + sum(str_count(pdf_text_cleaned, Y))
    }, X=expressions, Y=expressions_plural)
    return(expression_counts)
  }, error = function(e) {
    cat(paste("Error processing file:", pdf_file, "\n"))
    return(rep(NA, length(expressions)))
  })
}

# Function to list texts in a PDF file
list_pdf_texts <- function(pdf_file, expressions) {
  tryCatch({
    pdf_text <- pdf_text(pdf_file)
    
    # Remove line breaks, tabs, and multiple spaces
    pdf_text_cleaned <- gsub("[\r\n\t]+", " ", pdf_text)
    pdf_text_cleaned <- gsub(" +", " ", pdf_text_cleaned)
    
    return(pdf_text_cleaned)
  }, error = function(e) {
    cat(paste("Error processing file:", pdf_file, "\n"))
    return(rep(NA, length(expressions)))
  })
}

##################################

# Fetch COPOM dates
copomCalendar <- openxlsx::read.xlsx(meetings_file, sheet = 'CALENDAR', startRow = 2, colNames = TRUE)
copomCalendar$MEETING <- as.numeric(gsub("\\D", "", copomCalendar$MEETING))
copomCalendar$DATE <- openxlsx::convertToDate(copomCalendar$DATE)
copomCalendar <- copomCalendar[!is.na(copomCalendar$DATE),]
copomCalendar <- copomCalendar[order(copomCalendar$MEETING),]

# List all PDF files in the folder and count occurrences
pdf_files <- basename(list.files(pdf_folder, pattern = "\\.pdf$", full.names = TRUE))
expression_counts <- sapply(pdf_files,
                            count_expression_occurrences,
                            expressions = search_expressions_sing,
                            expressions_plural = search_expressions_plural)
names(expression_counts) <- basename(pdf_files)

# Create a data frame with file names and counts
pdf_data <- data.frame(t(expression_counts))
pdf_data$total <- rowSums(pdf_data)
pdf_data$meeting <- rownames(pdf_data)
pdf_data$nMeeting <- substring(pdf_data$meeting,1,3)
pdf_data$date <- as.Date(substring(pdf_data$meeting,7,16))

# Reshape the data from wide to long format
df_long <- pivot_longer(pdf_data, cols = make.names(search_expressions_sing), names_to = "Variable", values_to = "Value")

start_date <- as.Date("1999-01-01")
end_date <- as.Date("2023-10-01")


# Create the stacked bar plot
base_plot <- ggplot(df_long, aes(x = date, y = Value, fill = Variable)) +
  geom_bar(stat = "identity", width = 30) +
  labs(title = "Menções à taxa neutra na ata do Copom (em inglês)", x = "Reunião", y = "Frequência") +
  ggthemes::theme_economist() +
  xlim(start_date, end_date) +
  scale_x_date(breaks = seq(from = start_date, to = end_date, by = "1 year"), labels = scales::date_format("%Y")) +  # Quarterly labels
  scale_y_continuous(breaks = seq(0, max(df_long$total), by = 1)) +  # Set y-axis breaks
  guides(fill = guide_legend(title = "Expressões", label.theme = element_text(size = 9)))+
  theme(
    axis.title.x = element_text(size = 14, vjust = -2.5),  # Ajuste o título do eixo x
    axis.title.y = element_text(size = 14, vjust = 3.5),  # Ajuste o título do eixo y
  )

show(base_plot)

# Convert the ggplot to an interactive plot using plotly
interactive_plot <- ggplotly(base_plot)

# Display the interactive plot
interactive_plot