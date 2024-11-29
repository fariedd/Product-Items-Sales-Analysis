library(shiny)
library(plotly)
library(shinythemes)
library(bslib)

# Sample data
items_count_day_to_day <- data.frame(
  sqldate = as.Date(c('2021-11-21', '2021-11-22', '2021-11-23', '2021-11-24', '2021-11-25')),
  item_name = c(150, 200, 250, 300, 350)
)

day_to_day <- data.frame(
  sqldate = as.Date(c('2021-11-22', '2021-11-23', '2021-11-24', '2021-11-25', '2021-11-26', '2021-11-27', '2021-11-28', '2021-11-29')),
  day = c(22, 23, 24, 25, 26, 27, 28, 29),
  day_name = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', 'Monday'),
  saleamt = c(6897277, 6418734, 7054085, 8291045, 18181002, 9369157, 10970376, 16825420)
)

commission_to_day <- data.frame(
  sqldate = as.Date(c('2021-11-22', '2021-11-23', '2021-11-24', '2021-11-25', '2021-11-26', '2021-11-27', '2021-11-28', '2021-11-29')),
  day = c(22, 23, 24, 25, 26, 27, 28, 29),
  day_name = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', 'Monday'),
  commission = c(367870, 354323, 372445, 512287, 1105023, 511805, 671713, 1285350)
)

country_sales <- data.frame(
  sqldate = as.Date(c(
    '2021-11-22', '2021-11-22', '2021-11-22', '2021-11-22', '2021-11-22', '2021-11-23', '2021-11-23', '2021-11-23', '2021-11-23', '2021-11-23',
    '2021-11-24', '2021-11-24', '2021-11-24', '2021-11-24', '2021-11-24', '2021-11-25', '2021-11-25', '2021-11-25', '2021-11-25', '2021-11-25',
    '2021-11-25', '2021-11-25', '2021-11-26', '2021-11-26', '2021-11-26', '2021-11-26', '2021-11-26', '2021-11-27', '2021-11-27', '2021-11-27',
    '2021-11-27', '2021-11-27', '2021-11-28', '2021-11-28', '2021-11-28', '2021-11-28', '2021-11-28', '2021-11-29', '2021-11-29', '2021-11-29',
    '2021-11-29', '2021-11-29')),
  country_new = c(
    'Australia', 'Canada', 'United Kingdom', 'Other Countries', 'United States', 'Australia', 'Canada', 'United Kingdom', 'Other Countries', 'United States',
    'Australia', 'Canada', 'United Kingdom', 'Other Countries', 'United States', 'Australia', 'Canada', 'China', 'United Kingdom', 'Other Countries',
    'Singapore', 'United States', 'Australia', 'Canada', 'United Kingdom', 'Other Countries', 'United States', 'Australia', 'Canada', 'United Kingdom',
    'Other Countries', 'United States', 'Australia', 'Canada', 'United Kingdom', 'Other Countries', 'United States', 'Australia', 'Canada', 'United Kingdom',
    'Other Countries', 'United States'),
  saleamt_x = c(
    93197, 982064, 358898, 602486, 4859254, 149930, 1473099, 267453, 444790, 4083321,
    184342, 1152700, 336851, 462093, 4917264, 145188, 1758845, 83882, 281568, 473167,
    103962, 5444391, 258943, 2978348, 757900, 1115557, 13068980, 142723, 1192765, 264251,
    571375, 7197712, 176934, 1400572, 305834, 869092, 8217512, 177986, 1832752, 351350,
    916018, 13547116)
)

# Sample data for first table
table1 <- data.frame(
  Antecedent = c("Bowflex C6 Bike", "Printed Flannel Pajama Pants for Men", "adidas Tiro 21 Track Pants Black M Mens", "Galaxy Blue & Star Murano Charm", "adidas Essentials Fleece Open Hem 3-Stripes Pants Black M Mens"),
  Consequent = c("Bowflex Cardio Machine Mat", "Matching Printed Flannel Pajama Pants for Women", "adidas Tiro Track Pants Black M Mens", "Star & Crescent Moon Charm", "adidas Essentials Fleece Open Hem 3-Stripes Pants Dark Grey Heather M Mens"),
  Support = c(0.0018405277, 0.0013502937, 0.0013201916, 0.0010320716, 0.0009331648),
  Confidence = c(0.9596412556, 0.0561014829, 0.0864301802, 0.0938232995, 0.1043269231)
  #lift = c(362.8567428634, 13.9528888184, 15.1459283794, 31.8974527797, 44.0297483596)
)

# Sample data for second table
table2 <- data.frame(
  Antecedent = c("Apparel & Accessories > Clothing > Shirts & Tops", "Apparel & Accessories > Clothing > Shirts & Tops", "Apparel & Accessories > Clothing > Shirts & Tops", "Apparel & Accessories > Clothing > Shirts & Tops", "Apparel & Accessories > Shoes", "Apparel & Accessories > Clothing > Shirts & Tops"),
  Consequent = c("Apparel & Accessories > Clothing > Pants", "Apparel & Accessories > Clothing > Activewear", "Apparel & Accessories > Shoes", "Apparel & Accessories > Clothing", "Apparel & Accessories > Clothing > Activewear", "Apparel & Accessories > Clothing > Sleepwear & Loungewear"),
  Support = c(0.668460232, 0.347113514, 0.311178378, 0.272796911, 0.242409266, 0.190980695),
  Confidence = c(0.231961945, 0.120451632, 0.107981804, 0.094663077, 0.237495763, 0.066272085)
  #Lift = c(0.772101495, 0.441963595, 0.345650674, 0.446309359, 0.871424319, 0.655572831)
)

# Sample data for top selling product items
sample_data <- data.frame(
Product_Item = c("Theragun Elite Black - Smart Percussive Therapy Massager",
"Console Playstation 5",
"Sony PS5 PlayStation 5 (US Plug) Blu-ray Edition Console 3005718 White",
"Bowflex C6 Bike",
"Microsoft Xbox Series X (US Plug) RRT-00001 / RRT-00024 Black",
"Theragun Elite White - Smart Percussive Therapy Massager",
"Bowflex Max Trainer M6",
"Sony PS5 PlayStation 5 (US Plug) Digital Edition Console 3005719 White",
"Jordan 4 Retro Lightning (2021)",
"Jordan 12 Retro Royalty Taxi",
"Go Anywhere® Performance Un-Tucked Short Sleeve Shirt"),
Ammount_USD = c(1097250, 621001, 599392, 356184, 259001, 211071, 204770, 203385, 202048, 188433, 174975)
)
# Format Ammount_USD column to show values in millions or thousands
sample_data <- sample_data %>%
mutate(Ammount_USD = ifelse(Ammount_USD >= 1e6,
sprintf("%.2fM", Ammount_USD / 1e6),
sprintf("%dk", round(Ammount_USD / 1e3))))

# Sample data for top selling product categories
category_sample <- data.frame(
Product_Taxanomy = c("Apparel & Accessories > Shoes",
"Apparel & Accessories > Clothing > Shirts & Tops",
"Apparel & Accessories > Clothing > Outerwear > Coats & Jackets",
"Apparel & Accessories > Jewelry > Charms & Pendants",
"Apparel & Accessories > Jewelry > Rings",
"Arts & Entertainment > Hobbies & Creative Arts > Collectibles",
"Apparel & Accessories > Clothing > Pants",
"Apparel & Accessories > Clothing > Activewear",
"Home & Garden > Decor > Rugs",
"Health & Beauty > Personal Care > Massage & Relaxation > Massagers"),
Ammount_USD = c(21955169, 7006964, 3703841, 2982234, 2854551, 2589922, 2053210, 2041017, 1570417, 1490888)
)
# Format Ammount_USD column to show values in millions or thousands
category_sample <- category_sample %>%
mutate(Ammount_USD = ifelse(Ammount_USD >= 1e6,
sprintf("%.2fM", Ammount_USD / 1e6),
sprintf("%dk", round(Ammount_USD / 1e3))))
# Sample data for additional section
additional_data <- data.frame(
Product_Category = c(
"Apparel & Accessories > Shoes",
"Apparel & Accessories > Shoes",
"Apparel & Accessories > Shoes",
"Apparel & Accessories > Shoes",
"Apparel & Accessories > Shoes",
"Apparel & Accessories > Clothing > Shirts & Tops",
"Apparel & Accessories > Clothing > Shirts & Tops",
"Apparel & Accessories > Clothing > Shirts & Tops",
"Apparel & Accessories > Clothing > Shirts & Tops",
"Apparel & Accessories > Clothing > Shirts & Tops",
"Apparel & Accessories > Clothing > Outerwear > Coats & Jackets",
"Apparel & Accessories > Clothing > Outerwear > Coats & Jackets",

"Apparel & Accessories > Clothing > Outerwear > Coats & Jackets",
"Apparel & Accessories > Clothing > Outerwear > Coats & Jackets",
"Apparel & Accessories > Clothing > Outerwear > Coats & Jackets",
"Apparel & Accessories > Jewelry > Charms & Pendants",
"Apparel & Accessories > Jewelry > Charms & Pendants",
"Apparel & Accessories > Jewelry > Charms & Pendants",
"Apparel & Accessories > Jewelry > Charms & Pendants",
"Apparel & Accessories > Jewelry > Charms & Pendants",
"Apparel & Accessories > Jewelry > Rings",
"Apparel & Accessories > Jewelry > Rings",
"Apparel & Accessories > Jewelry > Rings",
"Apparel & Accessories > Jewelry > Rings",
"Apparel & Accessories > Jewelry > Rings"
),
Product_Item = c(
"Jordan 4 Retro Lightning (2021)",
"Jordan 12 Retro Royalty Taxi",
"Jordan 11 Retro Cool Grey (2021)",
"Jordan 3 Retro Pine Green",
"Jordan 4 Retro White Oreo (2021)",
"Go Anywhere® Performance Un-Tucked Short Sleeve Shirt",
"2021 Big Ten Football Championship - Michigan vs Iowa",
"Classic Retro-X Jacket - Men's",
"1996 Retro Nuptse Jacket - Men's",
"Men's Powder Search 2.0 3-In-1 Down Jacket",
"Women's Lodge Cascadian Down Parka",
"Men's Boundary Pass Down Parka",
"Men's Superior Down Parka",
"Women's Sun Valley Down Parka",
"Men's CirrusLite Down Jacket",
"Pandora Moments Snake Chain Slider Bracelet - Size 11.0 inches",
"Airplane Bracelet, Globe & Suitcase Dangle Charm",
"Mother & Daughter Hearts Dangle Charm",
"Murano Glass Sea Turtle Dangle Charm",
"Gingerbread Man Dangle Charm",
"French Pave Eternity Band in Platinum (1 1/2 ct. tw.)",
"French Pave Eternity Band in Platinum (2 1/2 ct. tw.)",
"8.08 Carat, Ideal Cut, F Color, VS1 clarity Cushion Diamond",
"French Pave Diamond Wedding Ring in 14k White Gold (1/3 ct. tw.)",
"Selene 7-Stone Diamond Anniversary Ring in 14k White Gold (1 ct. tw.)"
),
Ammount_USD = c(
202048, 188433, 170982, 165843, 160627,
174975, 65308, 65153, 55010, 51395,
152818, 142204, 107866, 88320, 86556,
54516, 52965, 47404, 39034, 38300,
75810, 56768, 51940, 32093, 31395
)
)
# Format Ammount_USD column to show values in millions or thousands
additional_data <- additional_data %>%
mutate(Ammount_USD = ifelse(Ammount_USD >= 1e6,
sprintf("%.2fM", Ammount_USD / 1e6),
sprintf("%dk", round(Ammount_USD / 1e3))))

# Define a hover template function
custom_hover <- function(date, country, sales) {
  if (date %in% c('2021-11-22', '2021-11-23', '2021-11-24', '2021-11-25', '2021-11-26', '2021-11-27', '2021-11-28', '2021-11-29')) {
    paste0('<b>', country, '</b><br>', format(sales, big.mark = ",", scientific = FALSE), ' USD<extra></extra>')
  } else {
    '<extra></extra>'
  }
}

# Apply hover template function to create hover templates for each row
country_sales$hover <- mapply(custom_hover, country_sales$sqldate, country_sales$country_new, country_sales$saleamt_x)


# UI
ui <- fluidPage(theme = shinytheme('spacelab'),
  #titlePanel("Product Items Sold Analysis"),
  tabsetPanel(
    tabPanel(
      "Objectives",
      fluidPage(
        tags$head(
          tags$style(HTML("
      .full-page-img {
        position: absolute;
        top: 0;
        left: 0;
        width: 85%;
        height: auto;
        object-fit: cover;
        z-index: -1;
      }
    "))
        ),
        tags$img(src = "landing page.png", alt = "Landing page image", class = "full-page-img")
      )
    ),
    tabPanel(
      "Methods",
      fluidPage(
        tags$head(
          tags$style(HTML("
        .contained-img {
          width: 95%;
          
         
          height: auto; /* Maintain aspect ratio */
          display: block; /* Ensures the image is treated as a block element */
          margin-left: auto; /* Center the image horizontally */
          margin-right: auto; /* Center the image horizontally */
          
          /* Ensure image does not overflow */ 
          max-width: 90%; 
          max-height: 100vh; /* Maximum height as the viewport height */
        }
      "))
        ),
        tags$img(src = "workflow.png", alt = "Landing page image", class = "contained-img")
      )
    ),
    
    tabPanel("Sales Trends",
             fluidPage(
               br(),
               fluidRow(
                 column(12,
                        h3(strong("Summary of Product Sales")),
                        p("This section shows a summary of the product sales data. Each value box represents key metrics for the product sales and graphs show daily sales values"),
                        style = "padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px; text-align: center;"
                 )
               ),
               fluidRow(
                 column(4,
                        div(style = "background-color: #0854C1; padding: 10px; margin-bottom: 20px; text-align: center; border: 1px solid #ccc; border-radius: 10px;",
                            h3("Total Revenue"),
                            div(style = "display: flex; justify-content: center; align-items: center;",
                                h1("$", style = "font-size: 48px; margin-right: 10px;"),
                                h2("84.01M", style = "font-size: 36px;")
                            )
                        )
                 ),
                 column(4,
                        div(style = "background-color: #0854C1; padding: 10px; margin-bottom: 20px; text-align: center; border: 1px solid #ccc; border-radius: 10px;",
                            h3("Total Commission"),
                            div(style = "display: flex; justify-content: center; align-items: center;",
                                h1("$", style = "font-size: 48px; margin-right: 10px;"),
                                h2("5.18M", style = "font-size: 36px;")
                            )
                        )
                 ),
                 column(4,
                        div(style = "background-color:#0854C1; padding: 10px; margin-bottom: 20px; text-align: center; border: 1px solid #ccc; border-radius: 10px;",
                            h3("Total Items Sold"),
                            div(style = "display: flex; justify-content: center; align-items: center;",
                                h1("📦", style = "font-size: 48px; margin-right: 10px;"),
                                h2("1.13M", style = "font-size: 36px;")
                            )
                        )
                 )
               ),
               
               fluidRow(
                 column(9,
                        h4("Daily Sales Revenue during Thanksgiving Week 2021"),
                        plotlyOutput("sales_plot"),
                        style = "padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;"
                 )
               ),
               fluidRow(
                 column(9,
                        h4("Daily Commission during Thanksgiving Week 2021"),
                        plotlyOutput("commission_plot"),
                        style = "padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;"
                 )
               ),
               fluidRow(
                 column(9,
                        h4("Daily Sales Per Country during Thanksgiving Week 2021"),
                        plotlyOutput("country_sales_plot"),
                        style = "padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;"
                 )
               )
             )
    ),
    tabPanel("Top selling Product Items",
             fluidPage(
               
               
               fluidRow(
                 column(12, 
                        div(style = "padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;text-align: center;",
                            h3(strong("Summary of Product Items and category")),
                            p("This section shows a summary of the product items and categories ranking."),
                        )
                 )
               ),
               
               fluidRow(
                 column(9, 
                        div(style = "overflow-y: scroll; max-height: 250px; padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                            h4("Top 10 Selling Product Items"),
                            p('Assuming that top selling product items are limited to top 10 items'),
                            tableOutput("table")
                        )
                 )
               ),
               
               fluidRow(
                 column(9,
                        div(style = "overflow-y: scroll; max-height: 250px; padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                            h4("Top 10 Selling Product Categories"),
                            p('Assuming that top selling product categories are limited to the top 10 categories'),
                            tableOutput("table_2")
                        )
                 )
               ),
               
               fluidRow(
                 column(9,
                        div(style = "overflow-y: scroll; max-height: 300px; padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                            h4("Top 10 Selling Product Items per Category"),
                            p('Assuming that top selling product items and categories are limited to the top 10'),
                            tableOutput("table_3")
                        )
                 )
               )
             )
    ),
    tabPanel("Product Association",
             fluidPage(
               h3(strong("Summary of Product Association")),
               p("This section shows a summary of product items and categories relationships."),
               fluidRow(
                 column(3, 
                        div(style = "background-color: #0854C1; padding: 10px; margin-bottom: 20px; text-align: center; border: 1px solid #ccc; border-radius: 10px;",
                            h3("Total Transactions Made"),
                            div(style = "display: flex; justify-content: center; align-items: center;",
                                #h1("$", style = "font-size: 48px; margin-right: 10px;"),
                                h2("232k", style = "font-size: 36px;")
                            )
                        )
                 ),
                 column(3, 
                        div(style = "background-color: #0854C1; padding: 10px; margin-bottom: 20px; text-align: center; border: 1px solid #ccc; border-radius: 10px;",
                            h3("Unique Items Sold"),
                            div(style = "display: flex; justify-content: center; align-items: center;",
                                #h1("C", style = "font-size: 48px; margin-right: 10px;"),
                                h2("119k", style = "font-size: 36px;")
                            )
                        )
                 ),
                 column(6, 
                        div(style = "background-color: #f0f0f0; padding: 10px; margin-bottom: 20px; text-align: center; border: 1px solid #ccc; border-radius: 10px;",
                            h4("Association Rules"),
                            p(HTML("<div style='text-align: left;'>
                            
      <ul>
          <li><b> Support: </b>How many times do these items appear together in a transaction (%).</li>
          <li><b>Confidence:</b> The likelihood that an itemset will appear if another itemset appears (%).</li>
      </ul>
    </div>")
                            )  
                        )
                 )
               ),
               
               fluidRow(
                 column(7, 
                        div(style = "overflow-y: scroll; max-height: 250px; padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                            h4('Top associations for Product Items'),
                            p(),
                            tableOutput("table1")
                        ),
                        div(style = "overflow-y: scroll; max-height: 250px; padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                            h4('Top associations for Product Categories'),
                            p(),
                            tableOutput("table2")
                        )
                 ),column(5,div(style = "overflow-y: scroll; max-height: 600px; padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                                h4(HTML('<li><b>Key Findings:</b></li>')),
                                p(HTML("<ul>
          <li><b>Bowflex C6 Bike & Bowflex Cardio Machine Mat:</b></li>
          <li>Support: Appear in 0.18% of transactions together.</li>
          <li>Confidence: When customers buy the Bowflex C6 Bike, there is a 96% chance they also buy the Bowflex Cardio Machine Mat.</li>
          
          <br>
          <li><b>Printed Flannel Pajama Pants for Men & Matching Printed Flannel Pajama Pants for Women:</b></li>
          <li>Support: Appear in 0.14% of transactions together.</li>
          <li>Confidence: When customers buy men's pajama pants, there is a 6% chance they also buy the matching women's pajama pants.</li>
         
          </ul>"),
                                  HTML("<ul>
          <li><b>Shirts & Pants:</b></li>
          <li>Support: 66.85% of transactions include both.</li>
          <li>Confidence: When customers buy shirts, there is a 23.20% chance they also buy pants.</li>
          
          <br>
          <li><b>Shirts & Activewear:</b></li>
          <li>Support: 34.71% of transactions include both.</li>
          <li>Confidence: When customers buy shirts, there is a 12.05% chance they also buy activewear.</li>
         
        </ul>")
                                )
                 ))
               )
               
               
               
             )
    ),
    tabPanel("Black Friday vs Cyber Monday",
             br(),
             div(style = "padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px; text-align: center;",
               h3(strong("Summary of Black Friday and Cyber Monday?")),
               p("How were product sales trends similar or different between Black Friday and Cyber Monday?")
               ),
             fluidPage(
               
               column(9,
                      h4("Daily Commission during Thanksgiving Week 2021"),
                      plotlyOutput("commission_plot_compare"),
                      style = "padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;"
               ),
               column(9,
                      p(),
                      div(style = " max-height: 400px; padding: 10px;margin-top: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                          h3(strong('Commission:')),
                          p(style = "font-size: 18px;",HTML("Cyber Monday had more commissioned items than Black Friday, <br> 
                                                            <strong>Conclusion:</strong> Cyber Monday is focused on online sales, which reach a larger audience with extended shopping time; where affiliates can be used to boost online traffic compared to Black Friday which focusses more on in-store shopping"))
                          
                      )
               ),
                      
               column(9,
                      h4("Daily Sales per Country during Thanksgiving Week 2021"),
                      plotlyOutput("dayo_plot_compare"),
                      style = "padding: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;"
               )
               
             ),
             column(9,
                    div(style = " max-height: 400px; padding: 10px;margin-top: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                        h3(HTML('<strong>Sales:</strong>')),
                        p(style = "font-size: 20px;",HTML("Sales almost doubled for both Black Friday and Cyber Monday, especially in the the United States but Cyber Monday had more sales, <br> 
                                                          <strong>Conclusion 1:</strong> Retailers often use Black Friday to attract a large crowd with in-store promotions. These promotions could be extended to Cyber Monday,offer exclusive online deals, sometimes with additional discounts which drive up sales <br><strong>Conclusion 2:</strong> Canada conversely had less sales on Cyber monday than Black Friday, which could mean that customers still prefer traditional instore deals than online shopping"))
                        
                    )
                    
                    
             )
    ),
    tabPanel("Recomendations",
             p(),
                      div(style = " max-height: 800px; padding: 20px;margin-top: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                          h3(HTML('<b>Business Recomendations:</b>')),
                          p(HTML("
                          <ul style='font-size: 18px;'>
         <h3><b>Black Friday and Cyber Monday Sales Spike:</b></h3>
  <ul>
    <li>Increase marketing and promotional sales on these days.</li>
    <li>Ensure that inventory levels are sufficient to meet increased demand, especially for US sales where customer spending almost doubles.</li>
    <li>For Cyber Monday, invest in enhancing online shopping experience. Ensure that websites can handle increased traffic smoothly, which improves user experience and can increase the conversion rate.</li>
  </ul>

  <h3><b>Top Selling Products and Categories:</b></h3>
  <ul>
    <li>Theragun Elite Black, gaming consoles, and Jordan Shoes are top sellers. To attract customers, push to feature these prominently in marketing campaigns.</li>
    <li>\"Bowflex C6 Bike\" and \"Bowflex Cardio Machine Mat\" are often bought together, we could offer complementary bundle discounts for these products and other similar products.</li>
  </ul>

  <h3><b>Data Driven Decision:</b></h3>
  <ul>
    <li>Models are only as good as the data used. In this case, the product_taxanomy still needs more cleaning on the correct cataloguing of items before they can be trained on a model. This will improve the implementation of recommendation tools and product association rules technique to identify items frequently bought-together items and create bundle deals or cross-selling opportunities.</li>
  </ul>

                                 </ul>"
                                 
                                 )
                          ) 
                      )
             ),
    tabPanel("Model Deployment",
             p(),
             div(style = " max-height: 800px; padding: 20px;margin-top: 20px; margin-bottom: 20px; background-color: #e9e9e9; border-radius: 10px;",
                 h3(HTML('<b>Model Production Design:</b>')),
                 p(HTML("
                          <ul style='font-size: 18px;'>
         <h3><b>Data Pre-processing and Model Training:</b></h3>
<ul>
  <li>Clean data, split into train and test.</li>
  <li>Create pipeline and train the model using <span class='package-name'>TfidfVectorizer</span> and <span class='package-name'>MultinomialNB</span></li>
  <li>Evaluate the model until optimal</li>
  <li>Save and serialize the model as joblib or pickle</li>
</ul>

<h3><b>Create an API:</b></h3>
<ul>
  <li>Create API using Flask or FastAPI</li>
  <li>Create model health check and model version endpoints</li>
  <li>Wrap the serialized model inside API and create model prediction pipeline endpoints</li>
</ul>

<h3><b>Security Measures:</b></h3>
<ul>
  <li>Secure the API endpoints using OAuth2 or JWT</li>
</ul>

<h3><b>Dockerize the Application:</b></h3>
<ul>
  <li>Create `requirements.txt` file listing all dependencies</li>
  <li>Create Dockerfile with requirements</li>
  <li>Containerize the app within the Dockerfile, build the Docker image and run container</li>
</ul>

<h3><b>Deploy Docker Image:</b></h3>
<ul>
  <li>For client-facing features that need frequent access, host the docker image on auto-scaling environments like AWS ECS or GCP Cloud Run, with load balancers to handle varying loads efficiently.</li>
</ul>

<h3><b>Continuous Integration and Deployment (CI/CD) Pipeline:</b></h3>
<ul>
  <li>For maintaining model performance set up automated pipelines using Jenkins, GitHub Actions, or GitLab CI.</li>
</ul>

  
  
          
                                 </ul>")
                 ) 
             )
             )
  )
)

# Server
# Server
server <- function(input, output) {
  output$plot <- renderPlotly({
    plot_ly(items_count_day_to_day, 
            x = ~sqldate, 
            y = ~item_name, 
            type = 'bar', 
            text = ~item_name, 
            textposition = 'outside',
            hoverinfo = 'none') %>%
      layout(
        hovermode = "x",
        xaxis = list(
          title = list(text = 'Thanksgiving Week November 2021', standoff = 20),
          tickformat = '%A %d %b',
          dtick = 'D1',
          showline = TRUE,
          linecolor = 'black'
        ),
        yaxis = list(
          title = list(text = 'Total product items sold', standoff = 20),
          showline = TRUE,
          linecolor = 'black'
        )
      )
  })
  
  output$sales_plot <- renderPlotly({
    plot_ly(day_to_day, 
            x = ~sqldate, 
            y = ~saleamt, 
            type = 'scatter', 
            mode = 'lines+markers', 
            hoverinfo = 'text',
            hovertemplate = '<b>%{x}</b>: %{y:.2s} USD<extra></extra>') %>%
      layout(
        hovermode = "x",
        xaxis = list(
          title = list(text = 'Thanksgiving Week November 2021', standoff = 20),
          tickformat = '%A %d %b',
          dtick = 'D1',
          showline = TRUE,
          linecolor = 'black'
        ),
        yaxis = list(
          title = list(text = 'Daily Sales Revenue (USD)', standoff = 20),
          showline = TRUE,
          linecolor = 'black'
        )
      )
    
  })
  
  output$commission_plot <- renderPlotly({
    plot_ly(commission_to_day, 
            x = ~sqldate, 
            y = ~commission, 
            type = 'scatter', 
            mode = 'lines+markers', 
            hoverinfo = 'text',
            hovertemplate = '<b>%{x}</b>: %{y:.2s} USD<extra></extra>') %>%
      layout(
        hovermode = "x",
        xaxis = list(
          title = list(text = 'Thanksgiving Week November 2021', standoff = 20),
          tickformat = '%A %d %b',
          dtick = 'D1',
          showline = TRUE,
          linecolor = 'black'
        ),
        yaxis = list(
          title = list(text = 'Daily Commission (USD)', standoff = 20),
          showline = TRUE,
          linecolor = 'black'
        )
      )
  })
  
  output$country_sales_plot <- renderPlotly({
    plot_ly(country_sales, 
            x = ~sqldate, 
            y = ~saleamt_x, 
            color = ~country_new, 
            type = 'bar', 
            textposition = 'outside',
            hoverinfo = 'text',
            hovertemplate = '<b>%{y:.2s} USD</b><extra></extra>') %>%
      layout(
        barmode = 'stack',
        hovermode = "x",
        xaxis = list(
          title = list(text = 'Thanksgiving Week November 2021', standoff = 20),
          tickformat = '%A %d %b',
          dtick = 'D1',
          showline = TRUE,
          linecolor = 'black'
        ),
        yaxis = list(
          title = list(text = 'Daily Sales Per Country (USD)', standoff = 20),
          showline = TRUE,
          linecolor = 'black'
        )
      )
  })
  output$table <- renderTable({
    head(sample_data, 10)
  }, width = "100%", align = "c", sanitize.text.function = function(x) x)
  
  output$table_2 <- renderTable({
    head(category_sample, 10)
  }, width = "100%", align = "c", sanitize.text.function = function(x) x)
  output$table_3 <- renderTable({
    head(additional_data, 25)
  }, width = "100%", align = "c", sanitize.text.function = function(x) x)
  output$table1 <- renderTable({
    formatted_table1 <- table1 
    formatted_table1[] <- lapply(formatted_table1, function(x) { if(is.numeric(x)) format(x, digits = 3, nsmall = 4) else x })
  }, width = "100%", align = "c", sanitize.text.function = function(x) x)
  
  output$table2 <- renderTable({
    head(table2, 3)
  }, width = "100%", align = "c", sanitize.text.function = function(x) x)
  output$commission_plot_compare <- renderPlotly({
    plot_ly(commission_to_day, 
        x = ~sqldate, 
        y = ~commission, 
        type = 'scatter', 
        mode = 'lines+markers', 
        hoverinfo = 'text',
        hovertemplate = '<b>%{x}</b>: %{y:.2s} USD<extra></extra>') %>%
  layout(
    hovermode = "x",
    xaxis = list(
      title = list(text = 'Thanksgiving Week November 2021', standoff = 20),
      tickformat = '%A %d %b',
      dtick = 'D1',
      showline = TRUE,
      linecolor = 'black'
    ),
    yaxis = list(
      title = list(text = 'Daily Commission (USD)', standoff = 20),
      showline = TRUE,
      linecolor = 'black'
    ),
    annotations = list(
      list(
        x = as.Date('2021-11-26'),
        y = 1105023,
        text = '<b>Black Friday</b>: 1.1M USD',
        xref = 'x',
        yref = 'y',
        showarrow = TRUE,
        arrowhead = 2,
        ax = -20,
        ay = -30
      ),
      list(
        x = as.Date('2021-11-29'),
        y = 1285350,
        text = '<b>Cyber Monday</b>: 1.3M USD',
        xref = 'x',
        yref = 'y',
        showarrow = TRUE,
        arrowhead = 2,
        ax = -20,
        ay = -30
      )
    )
  )

  })
  output$dayo_plot_compare <- renderPlotly({
    plot_ly(country_sales, 
            x = ~sqldate, 
            y = ~saleamt_x, 
            color = ~country_new, 
            type = 'bar',
            hoverinfo = 'text',
            textposition = 'outside',
            hovertemplate = ~hover) %>%
      layout(
        barmode = 'stack',
        hovermode = "x unified",
        xaxis = list(
          title = list(text = 'Thanksgiving Week November 2021', standoff = 20),
          tickformat = '%A %d %b',
          dtick = 'D1',
          showline = TRUE,
          linecolor = 'black'
        ),
        yaxis = list(
          title = list(text = 'Daily Sales Per Country (USD)', standoff = 20),
          showline = TRUE,
          linecolor = 'black'
        )
      )
    
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)


