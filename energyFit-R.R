# ---- Paketid ----
library(dplyr)
library(tidyr)
library(ggplot2)
library(randomForest)
library(shiny)

# ---- 1) Andmete laadimine ----
workouts <- read.csv("workouts.csv")
sleep    <- read.csv("sleep.csv")
energy   <- read.csv("energy_usage.csv")

# ---- 2) Andmete ühendamine ----
df <- merge(workouts, energy, by = "date", all = TRUE)
df <- merge(df, sleep,    by = "date", all = TRUE)

# Kuupäev veerg õigeks (väga oluline joondiagrammide jaoks)
df$date <- as.Date(df$date)

# Kui quality on tekst, muuda numbriks
if (is.character(df$quality)) {
  df$quality <- as.numeric(df$quality)
}

# ---- 3) Automaatne NA-kontroll ----
cat("NA kontroll algab...\n")
print(colSums(is.na(df)))
na_rows <- df[!complete.cases(df), ]
print(na_rows)

if (any(is.na(df))) {
  cat("Leidsin NA-d – täidan need automaatselt.\n")
  df <- tidyr::fill(df, everything(), .direction = "down")
  df[is.na(df)] <- 0
}

cat("NA kontroll lõpetatud – NA-d eemaldatud või täidetud.\n")

# ---- 4) Mudeli treenimine ----
model <- randomForest(
  kwh ~ duration_minutes + intensity + calories + avg_heart_rate,
  data  = df,
  ntree = 200
)

saveRDS(model, "model.rds")

# ---- 5) Graafikud ----

# Energiatarbimine ajas – JOON + punktid (group = 1, et joon ühendaks kõik punktid)
p1 <- ggplot(df, aes(x = date, y = kwh, group = 1)) +
  geom_line(color = "#2C7BE5", linewidth = 1.2) +
  geom_point(color = "#2C7BE5", size = 3) +
  labs(
    title = "Energiatarbimine ajas",
    x = "Kuupäev",
    y = "kWh"
  )

# Treeningu mõju energiatarbimisele – punktdiagramm
p2 <- ggplot(df, aes(x = duration_minutes, y = kwh, color = intensity)) +
  geom_point(size = 3) +
  labs(
    title = "Treeningu kestus vs energiatarbimine",
    x = "Treeningu kestus (min)",
    y = "kWh",
    color = "Intensiivsus"
  )

# Tulpdiagramm – treeningute jaotus intensiivsuse järgi
p3 <- ggplot(df, aes(x = factor(intensity))) +
  geom_bar(fill = "#2C7BE5") +
  labs(
    title = "Treeningute jaotus intensiivsuse järgi",
    x = "Intensiivsus",
    y = "Treeningute arv"
  )

# Sektordiagramm – une kvaliteedi osakaal
sleep_summary <- df %>%
  group_by(quality) %>%
  summarise(count = n())

p4 <- ggplot(sleep_summary, aes(x = "", y = count, fill = factor(quality))) +
  geom_col(width = 1) +
  coord_polar("y") +
  labs(
    title = "Une kvaliteedi osakaal",
    fill  = "Kvaliteet"
  )

# Une kvaliteedi trend ajas – siksakiline JOON + punktid
p5 <- ggplot(df, aes(x = date, y = quality, group = 1)) +
  geom_line(color = "#2C7BE5", linewidth = 1.2) +
  geom_point(color = "#2C7BE5", size = 3) +
  labs(
    title = "Une kvaliteedi trend ajas",
    x = "Kuupäev",
    y = "Une kvaliteet (1–5)"
  )

# ---- 6) Dashboard ----
ui <- fluidPage(
  h2("EnergyFit-R Dashboard"),
  plotOutput("energy"),
  plotOutput("workout"),
  plotOutput("intensity_bar"),
  plotOutput("sleep_pie"),
  plotOutput("sleep_trend")
)

server <- function(input, output) {
  output$energy        <- renderPlot(p1)
  output$workout       <- renderPlot(p2)
  output$intensity_bar <- renderPlot(p3)
  output$sleep_pie     <- renderPlot(p4)
  output$sleep_trend   <- renderPlot(p5)
}

shinyApp(ui, server)