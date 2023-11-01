#### LIBRARIES ###################

library(openxlsx)
library(ggplot2)
library(matrixStats)
library(dplyr)
library(ggrepel)
library(countrycode)
library(mgsub)

#### Set-up ###################

graph_path <- "C://Users//Eduardo//OneDrive//Projetos Acadêmicos//Meus Papers//Taxa Neutra - Modo de Usar/Output//"
weoDB_path <- "C://Users//Eduardo//OneDrive//Projetos Acadêmicos//Meus Papers//Taxa Neutra - Modo de Usar//Data//WEOOct2023all.xlsx"
weoClass_path <- "C://Users//Eduardo//OneDrive//Projetos Acadêmicos//Meus Papers//Taxa Neutra - Modo de Usar//Data//WEO_Classification.xlsx"

colDates <- as.character(seq(1980, 2028))

# Fetch database
weoDB <- openxlsx::read.xlsx(weoDB_path, colNames = TRUE, startRow = 1)
weoClass <- openxlsx::read.xlsx(weoClass_path, colNames = TRUE, startRow = 1)

# Clear empty rows
weoDB <- weoDB[!is.na(weoDB$Country), ]

# Turn 'n/a' and '--' into NA
dataValues <- weoDB[, colDates]
dataValues[dataValues == 'n/a'] = NA
dataValues[dataValues == '--'] = NA
weoDB[, colDates] <- dataValues

# Format as numeric
weoDB[, colDates] <- as.data.frame(lapply(weoDB[, colDates], as.numeric))

##### Get series
# Gross domestic product, constant prices (Percent change)
dbGDP <- weoDB[weoDB$WEO.Subject.Code == 'NGDP_RPCH', c('Country', colDates)]

# General government revenue (Percent of GDP)
dbGovRev <- weoDB[weoDB$WEO.Subject.Code == 'GGR_NGDP', c('Country', colDates)]

# General government total expenditure (Percent of GDP)
dbGovExp <- weoDB[weoDB$WEO.Subject.Code == 'GGX_NGDP', c('Country', colDates)]

# General government structural balance (Percent of potential GDP)
dbGovStructBalance <- weoDB[weoDB$WEO.Subject.Code == 'GGSB_NPGDP', c('Country', colDates)]

# Output gap in percent of potential GDP (Percent of potential GDP)
dbYGap <- weoDB[weoDB$WEO.Subject.Code == 'NGAP_NPGDP', c('Country', colDates)]

# General government net debt (Percent of GDP)
dbGovNetDebt <- weoDB[weoDB$WEO.Subject.Code == 'GGXWDN_NGDP', c('Country', colDates)]

# General government gross debt (Percent of GDP)
dbGovGrossDebt <- weoDB[weoDB$WEO.Subject.Code == 'GGXWDG_NGDP', c('Country', colDates)]

# Gross domestic product, current prices (U.S. dollars)
dbNGDP <- weoDB[weoDB$WEO.Subject.Code == 'NGDPD', c('Country', colDates)]


###### GET LARGEST COUNTRIES

translateNames <- function(countryNames, destination)
{
  countryTrans <- countrycode::countryname(
    sub(x = countryNames,
        pattern = "Micronesia",
        replacement = "Micronesia (Federated States of)"), 
    destination = destination)
  
  countryTrans <- mgsub::mgsub(string = countryTrans,
                      pattern = c(
                        "Micronesia (Federated States of)", 
                        "Hong Kong, RAE da China",
                        "Macau, RAE da China"
                        ),
                      replacement = c(
                        "Micronésia", 
                        "Hong Kong",
                        "Macau"
                        )
                      )
  
  return(countryTrans)
}

countryList <- dbNGDP[order(dbNGDP$'2019', na.last = FALSE),]$Country
countryList_G50 <- countryList[(length(countryList)-49):length(countryList)]
countryList_Advanced <- weoClass[weoClass$Group == 'Advanced Economies', 'Country']
countryList_Emerging <- weoClass[weoClass$Group == 'Emerging and Developing Economies', 'Country']

countryList <- translateNames(countryList, 'cldr.name.pt')
countryList_G50 <- translateNames(countryList_G50, 'cldr.name.pt')
countryList_Advanced <- translateNames(countryList_Advanced, 'cldr.name.pt')
countryList_Emerging <- translateNames(countryList_Emerging, 'cldr.name.pt')

###### CONFIGURE GRAPHS

weo_theme <- theme(
  axis.title = element_text(size = 16),
  axis.text = element_text(size = 12),
  plot.title = element_text(size = 20, margin = margin(t = 20)),
  plot.subtitle = element_text(size= 14),
  axis.title.x = element_text(margin = margin(t = 10)),  # Adjust the 'x' axis title margin
  axis.title.y = element_text(margin = margin(r = 10)),  # Adjust the 'y' axis title margin
  axis.text.x = element_text(margin = margin(t = 5)),   # Adjust the 'x' axis label margin
  axis.text.y = element_text(margin = margin(r = 5))    # Adjust the 'y' axis label margin
)


###### REVENUE / EXPENDITURE

# Set-up
colSampleDates <- as.character(2022)
dbX <- dbGovRev
dbY <- dbGovExp

# Organize
rownames(dbX) <- dbX$Country
rownames(dbY) <- dbY$Country
dbX <- dbX[, c('Country', colSampleDates)]
dbY <- dbY[, c('Country', colSampleDates)]

# Join
dbZ <- left_join(dbX, dbY, by = join_by(Country), suffix=c('Rev', 'Exp'))
rownames(dbZ) <- translateNames(dbZ$Country, destination = 'cldr.name.pt')

# Select countries
dbZ_Advanced <- dbZ[c(countryList_Advanced, 'Brasil'), ]
dbZ_Emerging <- dbZ[countryList_Emerging, ]
dbZ_G50 <- dbZ[countryList_G50, ]
dbZ_EmergingG50 <- dbZ[intersect(countryList_Emerging, countryList_G50), ]

# Get Region Cross Point
xThreshold <- dbZ['Brasil', 2]
yThreshold <- dbZ['Brasil', 3]

# Plot dispersion graph: Advanced
dbZ_Graph <- dbZ_Advanced
dfShade <- data.frame(
  x = c(xThreshold, max(dbZ_Graph[,2], na.rm=TRUE)),
  ymin = c(yThreshold, yThreshold),
  ymax = c(max(dbZ_Graph[,3], na.rm=TRUE), max(dbZ_Graph[,3], na.rm=TRUE))
)
p = ggplot(data = dbZ_Graph, aes(x = dbZ_Graph$'2022Rev', y = dbZ_Graph$'2022Exp', label = row.names(dbZ_Graph))) +
  geom_text_repel(max.overlaps = 20, size = 4) +
  geom_point() +
  annotate("rect", xmin = xThreshold, xmax = dfShade$x[2], ymin = dfShade$ymin[1], ymax = dfShade$ymax[1], alpha = .1, fill = "blue") +
  labs(title = "Fiscal em 2022: economias avançadas e Brasil",
       subtitle = "apenas economias com ambas as estatísticas disponíveis",
       x = "Receita do Governo Geral (% do PIB)",
       y = "Gasto do Governo Geral (% do PIB)") +
  weo_theme
# Save the plot with optimal dimensions for PowerPoint
ggsave(paste0(graph_path, "WEO_exp_rev_Avanced.png"), plot = p, width = 12, height = 6.2, units = "in", dpi = 300)


# Plot dispersion graph: Emerging
dbZ_Graph <- dbZ_Emerging
dfShade <- data.frame(
  x = c(xThreshold, max(dbZ_Graph[,2], na.rm=TRUE)),
  ymin = c(yThreshold, yThreshold),
  ymax = c(max(dbZ_Graph[,3], na.rm=TRUE), max(dbZ_Graph[,3], na.rm=TRUE))
)
p <- ggplot(data = dbZ_Graph, aes(x = dbZ_Graph$'2022Rev', y = dbZ_Graph$'2022Exp', label = row.names(dbZ_Graph))) +
  geom_text_repel(max.overlaps = 20) +
  geom_point() +
  annotate("rect", xmin = xThreshold, xmax = dfShade$x[2], ymin = dfShade$ymin[1], ymax = dfShade$ymax[1], alpha = .1, fill = "blue") +
  labs(title = "Fiscal em 2022: economias emergentes",
       subtitle = "apenas economias com ambas as estatísticas disponíveis",
       x = "Receita do Governo Geral (% do PIB)",
       y = "Gasto do Governo Geral (% do PIB)") +
  weo_theme
# Save the plot with optimal dimensions for PowerPoint
ggsave(paste0(graph_path, "WEO_exp_rev_Emerging.png"), plot = p, width = 12, height = 6.2, units = "in", dpi = 300)


# Plot dispersion graph: G50
dbZ_Graph <- dbZ_G50
dfShade <- data.frame(
  x = c(xThreshold, max(dbZ_Graph[,2], na.rm=TRUE)),
  ymin = c(yThreshold, yThreshold),
  ymax = c(max(dbZ_Graph[,3], na.rm=TRUE), max(dbZ_Graph[,3], na.rm=TRUE))
)
p <- ggplot(data = dbZ_Graph, aes(x = dbZ_Graph$'2022Rev', y = dbZ_Graph$'2022Exp', label = row.names(dbZ_Graph))) +
  geom_text_repel(max.overlaps = 20) +
  geom_point() +
  annotate("rect", xmin = xThreshold, xmax = dfShade$x[2], ymin = dfShade$ymin[1], ymax = dfShade$ymax[1], alpha = .1, fill = "blue") +
  labs(title = "Fiscal em 2022: 50 maiores economias do mundo",
       subtitle = "ordenadas pelo PIB nominal em USD em 2019; apenas economias com ambas as estatísticas disponíveis",
       x = "Receita do Governo Geral (% do PIB)",
       y = "Gasto do Governo Geral (% do PIB)") +
  weo_theme
# Save the plot with optimal dimensions for PowerPoint
ggsave(paste0(graph_path, "WEO_exp_rev_G50.png"), plot = p, width = 12, height = 6.2, units = "in", dpi = 300)


# Plot dispersion graph: Emerging in the G50
dbZ_Graph <- dbZ_EmergingG50
dfShade <- data.frame(
  x = c(xThreshold, max(dbZ_Graph[,2], na.rm=TRUE)),
  ymin = c(yThreshold, yThreshold),
  ymax = c(max(dbZ_Graph[,3], na.rm=TRUE), max(dbZ_Graph[,3], na.rm=TRUE))
)
p <- ggplot(data = dbZ_Graph, aes(x = dbZ_Graph$'2022Rev', y = dbZ_Graph$'2022Exp', label = row.names(dbZ_Graph))) +
  geom_text_repel(max.overlaps = 20) +
  geom_point() +
  annotate("rect", xmin = xThreshold, xmax = dfShade$x[2], ymin = dfShade$ymin[1], ymax = dfShade$ymax[1], alpha = .1, fill = "blue") +
  labs(title = "Fiscal em 2022: economias emergentes entre as 50 maiores economias do mundo",
       subtitle = "ordenadas pelo PIB nominal em USD em 2019; apenas economias com ambas as estatísticas disponíveis",
       x = "Receita do Governo Geral (% do PIB)",
       y = "Gasto do Governo Geral (% do PIB)") +
  weo_theme
# Save the plot with optimal dimensions for PowerPoint
ggsave(paste0(graph_path, "WEO_exp_rev_G50Emerging.png"), plot = p, width = 12, height = 6.2, units = "in", dpi = 300)


###### GROSS DEBT / NET DEBT

# Set-up
colSampleDates <- as.character(2022)
dbX <- dbGovGrossDebt
dbY <- dbGovNetDebt

# Organize
rownames(dbX) <- dbX$Country
rownames(dbY) <- dbY$Country
dbX <- dbX[, c('Country', colSampleDates)]
dbY <- dbY[, c('Country', colSampleDates)]

# Join
dbZ <- left_join(dbX, dbY, by = join_by(Country), suffix=c('Rev', 'Exp'))
rownames(dbZ) <- translateNames(dbZ$Country, destination = 'cldr.name.pt')

# Select countries
dbZ_Advanced <- dbZ[c(countryList_Advanced, 'Brasil'), ]
dbZ_Emerging <- dbZ[countryList_Emerging, ]
dbZ_G50 <- dbZ[countryList_G50, ]
dbZ_EmergingG50 <- dbZ[intersect(countryList_Emerging, countryList_G50), ]

# Get Region Cross Point
xThreshold <- dbZ['Brasil', 2]
yThreshold <- dbZ['Brasil', 3]

# Plot dispersion graph: Advanced
dbZ_Graph <- dbZ_Advanced
dfShade <- data.frame(
  x = c(xThreshold, max(dbZ_Graph[,2], na.rm=TRUE)),
  ymin = c(yThreshold, yThreshold),
  ymax = c(max(dbZ_Graph[,3], na.rm=TRUE), max(dbZ_Graph[,3], na.rm=TRUE))
)
p <- ggplot(data = dbZ_Graph, aes(x = dbZ_Graph$'2022Rev', y = dbZ_Graph$'2022Exp', label = row.names(dbZ_Graph))) +
  geom_text_repel(max.overlaps = 20) +
  geom_point() +
  annotate("rect", xmin = xThreshold, xmax = dfShade$x[2], ymin = dfShade$ymin[1], ymax = dfShade$ymax[1], alpha = .1, fill = "blue") +
  labs(title = "Fiscal em 2022: economias avançadas e Brasil",
       subtitle = "apenas economias com ambas as estatísticas disponíveis",
       x = "Dívida Bruta do Governo Geral (% do PIB)",
       y = "Dívida Líquida do Governo Geral (% do PIB)") +
  weo_theme
# Save the plot with optimal dimensions for PowerPoint
ggsave(paste0(graph_path, "WEO_gross_net_Advanced.png"), plot = p, width = 12, height = 6.2, units = "in", dpi = 300)


# Plot dispersion graph: Emerging
dbZ_Graph <- dbZ_Emerging
dfShade <- data.frame(
  x = c(xThreshold, max(dbZ_Graph[,2], na.rm=TRUE)),
  ymin = c(yThreshold, yThreshold),
  ymax = c(max(dbZ_Graph[,3], na.rm=TRUE), max(dbZ_Graph[,3], na.rm=TRUE))
)
p <- ggplot(data = dbZ_Graph, aes(x = dbZ_Graph$'2022Rev', y = dbZ_Graph$'2022Exp', label = row.names(dbZ_Graph))) +
  geom_text_repel(max.overlaps = 20) +
  geom_point() +
  annotate("rect", xmin = xThreshold, xmax = dfShade$x[2], ymin = dfShade$ymin[1], ymax = dfShade$ymax[1], alpha = .1, fill = "blue") +
  labs(title = "Fiscal em 2022: economias emergentes",
       subtitle = "apenas economias com ambas as estatísticas disponíveis",
       x = "Dívida Bruta do Governo Geral (% do PIB)",
       y = "Dívida Líquida do Governo Geral (% do PIB)") +
  weo_theme
# Save the plot with optimal dimensions for PowerPoint
ggsave(paste0(graph_path, "WEO_gross_net_Emerging.png"), plot = p, width = 12, height = 6.2, units = "in", dpi = 300)


# Plot dispersion graph: G50
dbZ_Graph <- dbZ_G50
dfShade <- data.frame(
  x = c(xThreshold, max(dbZ_Graph[,2], na.rm=TRUE)),
  ymin = c(yThreshold, yThreshold),
  ymax = c(max(dbZ_Graph[,3], na.rm=TRUE), max(dbZ_Graph[,3], na.rm=TRUE))
)
p <- ggplot(data = dbZ_Graph, aes(x = dbZ_Graph$'2022Rev', y = dbZ_Graph$'2022Exp', label = row.names(dbZ_Graph))) +
  geom_text_repel(max.overlaps = 20) +
  geom_point() +
  annotate("rect", xmin = xThreshold, xmax = dfShade$x[2], ymin = dfShade$ymin[1], ymax = dfShade$ymax[1], alpha = .1, fill = "blue") +
  labs(title = "Fiscal em 2022: 50 maiores economias do mundo",
       subtitle = "ordenadas pelo PIB nominal em USD em 2019; apenas economias com ambas as estatísticas disponíveis",
       x = "Dívida Bruta do Governo Geral (% do PIB)",
       y = "Dívida Líquida do Governo Geral (% do PIB)") +
  weo_theme
# Save the plot with optimal dimensions for PowerPoint
ggsave(paste0(graph_path, "WEO_gross_net_G50.png"), plot = p, width = 12, height = 6.2, units = "in", dpi = 300)


# Plot dispersion graph: Emerging in the G50
dbZ_Graph <- dbZ_EmergingG50
dfShade <- data.frame(
  x = c(xThreshold, max(dbZ_Graph[,2], na.rm=TRUE)),
  ymin = c(yThreshold, yThreshold),
  ymax = c(max(dbZ_Graph[,3], na.rm=TRUE), max(dbZ_Graph[,3], na.rm=TRUE))
)
p <- ggplot(data = dbZ_Graph, aes(x = dbZ_Graph$'2022Rev', y = dbZ_Graph$'2022Exp', label = row.names(dbZ_Graph))) +
  geom_text_repel(max.overlaps = 20) +
  geom_point() +
  annotate("rect", xmin = xThreshold, xmax = dfShade$x[2], ymin = dfShade$ymin[1], ymax = dfShade$ymax[1], alpha = .1, fill = "blue") +
  labs(title = "Fiscal em 2022: economias emergentes entre as 50 maiores economias do mundo; apenas economias com ambas as estatísticas disponíveis",
       subtitle = "ordenadas pelo PIB nominal em USD em 2019",
       x = "Dívida Bruta do Governo Geral (% do PIB)",
       y = "Dívida Líquida do Governo Geral (% do PIB)") +
  weo_theme
# Save the plot with optimal dimensions for PowerPoint
ggsave(paste0(graph_path, "WEO_gross_net_G50Emerging.png"), plot = p, width = 12, height = 6.2, units = "in", dpi = 300)


######################

####### Build graph

dbX <- dbGovExp
colSampleDates <- as.character(seq(2000, 2022))
rownames(dbX) <- dbX$Country
dbX <- dbX[, colSampleDates]

# Calculate statistics
dbSTD <- apply(dbX, 1, sd, na.rm = TRUE)
dbMEAN <- rowMeans(dbX, na.rm = TRUE)
dbX$STD <- dbSTD
dbX$MEAN <- dbMEAN
dbX$CV <- dbSTD / dbMEAN

# Remove irrelevant countries
dbX <- dbX[countryList_G50, ]

# Order
dbX <- dbX[order(dbX$'2022'), ]

# Label
dbX$Labels <- rownames(dbX)
dbX$Labels <- factor(dbX$Labels, levels = rownames(dbX))

# Plot bar graph
ggplot(data = dbX, aes(x = Labels, y = dbX$'2022')) +
  geom_bar(stat = "identity", fill = "blue") +
  geom_text(aes(label = round(dbX$'2022', digits=1) ), vjust = -0.5, size = 3) +
  labs(title = "Receita: % do PIB", x = "Country", y = "Value") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


