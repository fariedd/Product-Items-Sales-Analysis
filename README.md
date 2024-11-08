# README

## Overview
This project involves building a model to classify product items based on Google catalog categories and analyze purchasing patterns using market basket association rules. The workflow included data cleaning, model training with text vectorization and classification techniques, and a results dashboard to showcase insights.

## Methods and Statistics

### Data Cleaning
- Product items were categorized using Google catalog merchant values (data sourced from [Google Merchant Support](https://support.google.com/merchants/answer/6324436?sjid=11384066497760467600-EU)).
- Items not following the Google catalog format or with multiple category labels were removed. Misclassified items were identified (e.g., PS5 and Xbox consoles labeled under "Art & Entertainment" instead of "Electronics > Video Game Consoles").
- A rule-based filtering system was suggested to adjust misclassified items. An example Python function for correcting categories is provided:

    ```python
    def correct_categories(row):
        if 'Sony PS5 PlayStation 5' in row['item_name'] or 'Microsoft Xbox Series X' in row['item_name']:
            return 'Electronics > Video Game Consoles'
        return row['category']
    ```

### Model Training and Pipeline
1. **Vectorization**: Text data was converted to numerical vectors using `TF-IDF` (TfidfVectorizer), capturing term importance across the product catalog.
2. **Classification**: A `RandomForestClassifier` predicted product categories from the TF-IDF-transformed data. A train-test split evaluated model performance, using metrics like accuracy, F1 score, precision, and recall, with both weighted and macro averages for balanced insights.
3. **Multinomial Naive Bayes Alternative**: Due to the dataset's size (>100,000 rows), a Multinomial Naive Bayes classifier was chosen for optimal performance and computational efficiency in high-dimensional text data.

### Market Basket Analysis
Market basket association rule analysis identified frequently purchased items, quantified by:
- **Support**: Probability of an item set's occurrence out of total transactions.
- **Confidence**: Probability of both items occurring together if one item is already present.
- **Lift**: Strength of the association between items; values greater than 1 indicate a stronger relationship.

Due to computational constraints, support, confidence, and lift metrics were manually calculated.

## Results
An interactive dashboard was deployed to visualize sales trends, insights, and business recommendations. Access it [here](https://farisayi-dakwa.shinyapps.io/Thanksgiving_week_sales/).

---

This README provides an outline of the project's methodology, the model pipeline, and access to the final dashboard. For questions or additional details, contact Farisayi Dakwa.
