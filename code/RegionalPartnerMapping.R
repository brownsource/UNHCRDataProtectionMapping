################################################################################
# CREATES CSV TABLES AND SELECTION OF GRAPHICS SHOWING PARTNERS IN THE REGION
# AND FOR EACH COUNTRY.

# INPUTS: 
# ../../private/data/RegionalPartnerMapping/regional_partners_nodes.csv
# ../../private/data/RegionalPartnerMapping/regional_partners_edges.csv

# CLEAR WORKSPACE
rm(list = ls()) # Remove all the objects we created so far.

# INSTALL PACKAGES IF REQUIRED
if(!require(extrafont)){
    install.packages("extrafont")
}
if(!require(igraph)){
    install.packages("igraph")
}
if(!require(devtools)){
    install.packages("devtools")
}

# INSTALL LIBRARIES IF REQUIRED
#!! NEED TO CHANGE THIS BLOCK OF CODE !!#
library(extrafont)
font_import()
loadfonts()
library(igraph)
if (!require("ForceAtlas2")) devtools::install_github("analyxcompany/ForceAtlas2")
library("ForceAtlas2")
library(plyr)

# LOAD THE DATA
import.Edges <- data.frame(read.csv("../private/data/RegionalPartnerMapping/regional_partners_edges.csv", 
                                    header = TRUE, stringsAsFactors = FALSE))
import.Nodes <- data.frame(read.csv("../private/data/RegionalPartnerMapping/regional_partners_nodes.csv", 
                                    header = TRUE, stringsAsFactors = FALSE))

# CREATE LIST OF LEVELS TO RUN AT
country.Levels <- c("Regional") # "Jordan", "Lebanon", "Egypt", "Iraq", "Turkey" Not included at the moment

# CREATE IGRAPH OBJECT
graph.Regional.Partners <- graph_from_data_frame(d=import.Edges, vertices = import.Nodes, directed = F)
graph.Regional.Partners <- simplify(graph.Regional.Partners, remove.multiple = F, remove.loops = T)

# CREATE LIST OF GRAPHS CREATED
all.Graphs           <- list(graph.Regional.Partners)

all.Graphs.Layouts   <- list(1)

# FIX THE GRAPH PLOT LAYOUT PARAMETERS FOR EACH GRAPH
for (i in 1:length(all.Graphs)) {
    all.Graphs.Layouts[[i]] <- layout.forceatlas2(all.Graphs[[i]], 
                                                  directed = FALSE,
                                                  iterations = 500,
                                                  linlog = FALSE,
                                                  pos = NULL, 
                                                  nohubs = FALSE, 
                                                  k = 200, 
                                                  gravity = 0.5, 
                                                  ks = 0.1, 
                                                  ksmax = 10, 
                                                  delta = 1, 
                                                  center = NULL, 
                                                  #tolerate = 0.1, 
                                                  dim = 2, 
                                                  plotstep = 500, 
                                                  plotlabels = FALSE)
}

# CREATE LIST OF REGIONAL CHARTS TO GENERATE
regional.Graphs.Outputs   <- c("Regional_Partners_All", 
                               "Regional_Partners_All_DSA",
                               "Regional_Partners_All_JDSA",
                               "Regional_Partners_All_LDSA")

# SAVE PNGs OF CHARTS
source("code/F.OutputForceAtlas.R")

# Regional
OutputForceAtlas(graph.Regional.Partners, regional.Graphs.Outputs[1], all.Graphs.Layouts[[1]], 
                 graph.Labels = TRUE, highlight.DSA = "No", node.Scale = 1, 
                 "../private/output/RegionalPartnerMapping/")
OutputForceAtlas(graph.Regional.Partners, regional.Graphs.Outputs[1], all.Graphs.Layouts[[1]], 
                 graph.Labels = FALSE, highlight.DSA = "No", node.Scale = 1, 
                 "../private/output/RegionalPartnerMapping/")
OutputForceAtlas(graph.Regional.Partners, regional.Graphs.Outputs[2], all.Graphs.Layouts[[1]], 
                 graph.Labels = TRUE, highlight.DSA = "All", node.Scale = 1, 
                 "../private/output/RegionalPartnerMapping/")
OutputForceAtlas(graph.Regional.Partners, regional.Graphs.Outputs[2], all.Graphs.Layouts[[1]], 
                 graph.Labels = FALSE, highlight.DSA = "All", node.Scale = 1, 
                 "../private/output/RegionalPartnerMapping/")
OutputForceAtlas(graph.Regional.Partners, regional.Graphs.Outputs[3], all.Graphs.Layouts[[1]], 
                 graph.Labels = TRUE, highlight.DSA = "Jordan", node.Scale = 1, 
                 "../private/output/RegionalPartnerMapping/")
OutputForceAtlas(graph.Regional.Partners, regional.Graphs.Outputs[3], all.Graphs.Layouts[[1]], 
                 graph.Labels = FALSE, highlight.DSA = "Jordan", node.Scale = 1, 
                 "../private/output/RegionalPartnerMapping/")
OutputForceAtlas(graph.Regional.Partners, regional.Graphs.Outputs[4], all.Graphs.Layouts[[1]], 
                 graph.Labels = TRUE, highlight.DSA = "Lebanon", node.Scale = 1, 
                 "../private/output/RegionalPartnerMapping/")
OutputForceAtlas(graph.Regional.Partners, regional.Graphs.Outputs[4], all.Graphs.Layouts[[1]], 
                 graph.Labels = FALSE, highlight.DSA = "Lebanon", node.Scale = 1, 
                 "../private/output/RegionalPartnerMapping/")

# Create bar chart of types
Type <- factor(import.Nodes[,"type"])
barplot(table(Type))


rm(list = ls()) # Remove all the objects we created so far.