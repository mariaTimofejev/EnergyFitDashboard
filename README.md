## EnergyFit-R 

Tervise- ja treeninguandmete analüüs R-is

EnergyFit-R on R-is loodud analüütikaprojekt, mis ühendab treeningu-, une- ja energiatarbimise andmed ning kuvab tulemused interaktiivses Shiny dashboardis.

Projekti eesmärk on muuta andmed lihtsasti mõistetavaks ning tuua välja erinevaid mustreid treeningu, une ja energiatarbimise vahel.

- energiatarbimise muutust ajas
- treeningu kestvuse ja energiakulu seost
- treeningute jaotust intensiivsuse järgi
- une kvaliteedi jaotust ja trendi
- kombineeritud andmetest leitud mustreid

# Projektis kasutan:

R ja Shiny – dashboardi ja analüüsi loomiseks
andmete puhastamist – puuduvate väärtuste kontroll ja töötlemine
andmete visualiseerimist – erinevad graafikud ja trendid
Random Forest mudelit – energiatarbimise prognoosimiseks
model.rds – treenitud mudeli salvestamiseks ja taaskasutamiseks

# Projekti struktuur
EnergyFit-R/
├── energyfit.R
├── workouts.csv
├── sleep.csv
├── energy_usage.csv
├── model.rds
├── energy_plot.png
├── workout_effect.png
└── README.md

# Käivitamine

Ava projekt RStudios või VS Code'is ja käivita:

source("energyfit.R")

Dashboard avaneb aadressil:

http://127.0.0.1:3799

# Projekti eesmärk

See projekt näitab minu praktilist huvi andmeanalüüsi, visualiseerimise ja masinõppe vastu ning oskust muuta erinevatest allikatest pärinevad andmed arusaadavaks analüütiliseks lahenduseks.
