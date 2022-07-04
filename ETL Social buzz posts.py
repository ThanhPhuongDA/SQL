#!/usr/bin/env python
# coding: utf-8

# In[1]:


#The ETL project aims to sort out top 5 content categories that audience posted on Social Buzz platform
# The dataset is collected from the Virtual internship of Accenture North America https://www.theforage.com/modules/hzmoNKtzvAzXsEqx8/zjxeuu5mYzBuZw3fe?ref=FgLR7mNp5iAjGzqFd


# In[2]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import datetime

  


# In[3]:


import findspark
findspark.init()
findspark.find()


# In[4]:


import pyspark
from pyspark import SparkConf, SparkContext
from pyspark.sql import SparkSession, SQLContext
from pyspark.sql import *
from pyspark.sql.functions import *


# In[5]:


df1 = pd.read_csv("C:/Users/phuon/Downloads/Virtual internship Accenture/SBReactions.csv",sep=',')
df1.head()


# In[6]:


df1.info()


# In[7]:


df1 = pd.DataFrame(df1)
df1.drop(df1.columns[0], axis=1, inplace=True)


# In[8]:


df1['Datetime'] = pd.to_datetime(df1['Datetime']).dt.date
print(df1.head())


# In[9]:


df1 = df1.dropna(axis=0,subset=['Type'])


# In[10]:


print(df1)


# In[11]:


df1.loc[:,'Type'] = df1.loc[:, 'Type'].str.lower()
print(df1)


# In[12]:


df2 = pd.read_csv("C:/Users/phuon/Downloads/Virtual internship Accenture/SBReactionTypes.csv",sep=',')
print(df2)


# In[13]:


df2 = pd.DataFrame(df2)
df2.drop(df2.columns[0], axis=1, inplace=True)
print(df2)


# In[14]:


merged1 = df1.merge(df2, on='Type',how='left')


# In[15]:


print(merged1)


# In[16]:


merged1.info()


# In[17]:


merged1.set_index("Content ID", inplace=True)


# In[18]:


df3 = pd.read_csv("C:/Users/phuon/Downloads/Virtual internship Accenture/SBContent.csv",sep=',')
df3.head()


# In[19]:


df3 = pd.DataFrame(df3)
df3.drop(df3.columns[0], axis=1, inplace=True)
print(df3)


# In[20]:


df3.rename(columns = {'Type':'Contenttypes'}, inplace = True)


# In[21]:


print(df3)


# In[22]:


df3.loc[:,'Contenttypes'] = df3.loc[:, 'Contenttypes'].str.lower()
print(df3)


# In[23]:


df = pd.merge(
    left=merged1,
    right=df3[['Content ID','Category']],
    on='Content ID',
    how='left'
)

print(df)


# In[24]:


df.columns


# In[25]:


df['Category'] = df['Category'].str.replace('"', '') 


# In[26]:


df.loc[:,'Category'] = df.loc[:, 'Category'].str.lower()


# In[27]:


df.rename(columns = {'Content ID':'Content_ID','User ID': 'User_ID'}, inplace = True)


# In[28]:


df.head()


# In[29]:


df.to_csv('Final_data.csv',index=False)


# In[30]:


from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()


# In[31]:


df = spark.read.option('inferSchema',True).option('header', True).csv("C:/Users/phuon/Final_data.csv")


# In[32]:


df.show()


# In[33]:


df.printSchema()


# In[34]:


# Create a temporary table
df.createOrReplaceTempView('df')


# In[35]:


#Count distinct categories
df.select(countDistinct("Category")).show()


# In[36]:


# There are 16 distinct content categories that users usually post about on Social Buzz platform


# In[37]:


#Count distinct Sentiment
df.select(countDistinct("Sentiment")).show()


# In[38]:


df.select("Sentiment").distinct().show()


# In[39]:


# There are 3 types of sentimental reaction towards a content: positive, neutral and negative


# In[40]:


# Top 5 Categories based on sum of popularity scores
spark.sql("SELECT Category,                  SUM(Score) as sum_scores          FROM df          GROUP BY Category          ORDER BY SUM(Score) DESC          LIMIT 5").show()


# In[41]:


# Top 5 most popular categories of posts are animals, science, healthy eating, technology and food in a descending order.

# Animals had an aggregate popularity score of around 75K. 
# It is very interesting to see both food and healthy eating within the top 5, 
# it really shows what people enjoy food-related content. 
# But also interesting to see technology & science in the most popular content categories too. 
#Fairly speaking, users favor "real-life" content on this platform.


# In[42]:


# Top 5 Categories based on sum of popularity scores
spark.sql("SELECT Category,                  COUNT(Content_ID) AS count_posts          FROM df          GROUP BY Category          ORDER BY COUNT(Content_ID) DESC          LIMIT 5").show()


# In[ ]:


# It is interesting to see that Categories with higher number of posts will also receiver higher scores


# In[67]:


# Total number of posts each month
spark.sql("SELECT month(Datetime) AS Month,                  COUNT(Content_ID) AS count_posts          FROM df          GROUP BY Month          ORDER BY count_posts DESC          ").show()


# In[ ]:


# The most common month for users to post within was May, January, August & December
#since these are seasonal months with  many holidays and events, 
#this is interesting to know that people are most active during these months!

