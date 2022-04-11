#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Import libraries
import os
import numpy
import pandas as pd


# In[2]:


get_ipython().system('pip install psycopg2')


# In[3]:


import psycopg2


# In[9]:


get_ipython().system('pip install ipython-sql')


# In[8]:


import sqlite3


# In[10]:


# create a dataframe to import data for the tutorial
df= pd.DataFrame({'name': ['Juan', 'Victoria', 'Mary'], 
                  'age': [23,34,43], 
                  'city': ['Miami', 'Buenos Aires','Santiago']})

df


# In[11]:


# We will sqlite3 library and create a connection
cnn = sqlite3.connect('jupyter_sql_tutorial.db')


# In[12]:


df.to_sql('people', cnn)


# In[13]:


get_ipython().run_line_magic('load_ext', 'sql')


# In[14]:


get_ipython().run_line_magic('sql', 'sqlite:///jupyter_sql_tutorial.db')


# In[15]:


get_ipython().run_cell_magic('sql', '', 'SELECT *\nFROM people')


# In[16]:


get_ipython().run_cell_magic('sql', '', 'SELECT COUNT(*)\nFROM people')


# In[18]:


get_ipython().run_cell_magic('sql', '', 'SELECT round(avg(age),2) as age_average\nFROM people')


# In[ ]:




